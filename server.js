const express = require('express');
const cors = require('cors');

const app = express();

// ==========================================
// MIDDLEWARE
// ==========================================
// Allow all origins for development (fixes CORS issues)
app.use(cors({
  origin: '*', 
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization']
}));

app.use(express.json());

// Request logger
app.use((req, res, next) => {
  const ts = new Date().toISOString();
  console.log(`[${ts}] ${req.method} ${req.originalUrl}`);
  next();
});

// ==========================================
// IN-MEMORY DATA STORES
// ==========================================
const usersDb = new Map();
const otpStore = new Map();
const bookingsDb = new Map();

// Seed initial test data
usersDb.set('rgrtw5@cmdi.edu.ph', {
  fullName: 'Alex Jimenez',
  email: 'rgrtw5@cmdi.edu.ph',
  password: 'password123',
  isVerified: true,
});
otpStore.set('rgrtw5@cmdi.edu.ph', {
  otp: '123456',
  expiresAt: Date.now() + 10 * 60 * 1000,
});

// ==========================================
// HELPERS
// ==========================================
const OTP_TTL_MS = 10 * 60 * 1000;

function generateOtp() {
  return Math.floor(100000 + Math.random() * 900000).toString();
}

function isValidEmail(email) {
  return typeof email === 'string' && /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

function isCmdiEmail(email) {
  return isValidEmail(email) && email.toLowerCase().endsWith('@cmdi.edu.ph');
}

// ==========================================
// PANEL 1: SPLASH & CONFIGURATION API
// ==========================================
app.get('/api/app/config', (req, res) => {
  res.status(200).json({
    appName: 'CMDI ShareTrip',
    version: '1.0.0',
    status: 'online',
    supportedDomains: ['cmdi.edu.ph'],
  });
});

app.get('/health', (req, res) => {
  res.status(200).json({ status: 'ok', uptime: process.uptime() });
});

// ==========================================
// PANEL 2: LOGIN / SIGN IN API
// ==========================================
app.post('/api/auth/login', (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ success: false, error: 'Email and password are required.' });
  }

  const user = usersDb.get(email);
  if (!user) {
    return res.status(404).json({ success: false, error: 'User account not found.' });
  }

  if (user.password && user.password !== password) {
    return res.status(401).json({ success: false, error: 'Incorrect password.' });
  }

  if (!user.isVerified) {
    return res.status(403).json({ success: false, error: 'Account not yet verified.', email: user.email });
  }

  return res.status(200).json({
    success: true,
    message: 'Login successful.',
    token: 'jwt_sample_token_987654321',
    user: {
      email: user.email,
      fullName: user.fullName,
      isVerified: user.isVerified,
    },
  });
});

// ==========================================
// PANEL 3: REGISTRATION API
// ==========================================
app.post('/api/auth/register', (req, res) => {
  const { fullName, email, password } = req.body;

  if (!fullName || !email || !password) {
    return res.status(400).json({ success: false, error: 'All fields are required.' });
  }

  if (!isCmdiEmail(email)) {
    return res.status(400).json({ success: false, error: 'Please use a valid CMDI student email address.' });
  }

  if (usersDb.has(email) && usersDb.get(email).isVerified) {
    return res.status(409).json({ success: false, error: 'An account with this email already exists.' });
  }

  usersDb.set(email, { fullName, email, password, isVerified: false });

  const generatedOtp = generateOtp();
  otpStore.set(email, { otp: generatedOtp, expiresAt: Date.now() + OTP_TTL_MS });

  console.log(`[AUTH] Generated OTP for ${email}: ${generatedOtp}`);

  return res.status(201).json({
    success: true,
    message: 'Account created! Verification code sent.',
    email,
    devOtp: generatedOtp,
  });
});

// ==========================================
// PANEL 4: OTP VERIFICATION API
// ==========================================
app.post('/api/auth/verify-otp', (req, res) => {
  const { email, otp } = req.body;

  if (!email || !otp) return res.status(400).json({ success: false, error: 'Email and OTP required.' });
  if (!/^\d{6}$/.test(otp)) return res.status(400).json({ success: false, error: 'OTP must be 6 digits.' });

  const record = otpStore.get(email);
  if (!record) return res.status(400).json({ success: false, error: 'No OTP request found.' });
  if (Date.now() > record.expiresAt) {
    otpStore.delete(email);
    return res.status(400).json({ success: false, error: 'OTP expired.' });
  }
  if (record.otp !== otp) return res.status(400).json({ success: false, error: 'Invalid code.' });

  otpStore.delete(email);
  const user = usersDb.get(email);
  if (!user) return res.status(404).json({ success: false, error: 'User not found.' });

  user.isVerified = true;
  usersDb.set(email, user);

  return res.status(200).json({ success: true, message: 'Account verified.', user: { email, fullName: user.fullName, status: 'Verified' } });
});

app.post('/api/auth/resend-otp', (req, res) => {
  const { email } = req.body;
  if (!email) return res.status(400).json({ success: false, error: 'Email required.' });
  if (!usersDb.has(email)) return res.status(404).json({ success: false, error: 'No account found.' });

  const newOtp = generateOtp();
  otpStore.set(email, { otp: newOtp, expiresAt: Date.now() + OTP_TTL_MS });

  console.log(`[AUTH] Resent OTP for ${email}: ${newOtp}`);

  return res.status(200).json({ success: true, message: 'New code sent.', devOtp: newOtp });
});

// ==========================================
// PANEL 5: PROFILE API
// ==========================================
app.get('/api/auth/profile', (req, res) => {
  const email = req.query.email || 'rgrtw5@cmdi.edu.ph';
  const user = usersDb.get(email);

  if (!user) return res.status(404).json({ success: false, error: 'User not found.' });

  res.status(200).json({
    success: true,
    user: {
      email,
      fullName: user.fullName,
      status: user.isVerified ? 'Verified' : 'Unverified',
      verifiedAt: user.isVerified ? new Date().toISOString() : null,
    },
  });
});

// ==========================================
// PANEL 6: RIDES API
// ==========================================
const ALL_RIDES = [
  {
    id: '1',
    plateNumber: 'LAG-7841',
    vehicleType: 'Tricycle',
    vehicleModel: 'Kawasaki Tricycle',
    isVerifiedDriver: true,
    status: 'Available',
    driverName: 'Ramon Dela Rosa',
    driverInitials: 'RD',
    rating: 4.8,
    pickup: 'Bitin Junction',
    destination: 'CMDI Main Campus Gate',
    seatsLeft: 2,
    departureTime: '6:30 AM',
    eta: '4 min',
    fare: 15.0,
  },
  {
    id: '2',
    plateNumber: 'ABC-1234',
    vehicleType: 'Van',
    vehicleModel: 'Toyota HiAce',
    isVerifiedDriver: true,
    status: 'Available',
    driverName: 'Juan Cruz',
    driverInitials: 'JC',
    rating: 4.9,
    pickup: 'Maitim Junction',
    destination: 'CMDI Main Campus Gate',
    seatsLeft: 5,
    departureTime: '7:00 AM',
    eta: '10 min',
    fare: 25.0,
  },
  {
    id: '3',
    vehicleType: 'Motorcycle',
    vehicleModel: 'Honda Click 125',
    driverName: 'Mark Santos',
    driverInitials: 'MS',
    rating: 4.7,
    pickup: 'Tranca',
    destination: 'CMDI Bay Campus 2',
    seatsLeft: 1,
    departureTime: '6:45 AM',
    fare: 20.0,
  },
  {
    id: '4',
    vehicleType: 'Car',
    vehicleModel: 'Toyota Vios',
    driverName: 'Anna Reyes',
    driverInitials: 'AR',
    rating: 4.9,
    pickup: 'Los Baños',
    destination: 'CMDI Main Campus Gate',
    seatsLeft: 3,
    departureTime: '7:15 AM',
    fare: 30.0,
  },
  {
    id: '5',
    vehicleType: 'Shuttle',
    vehicleModel: 'CMDI Shuttle A',
    driverName: 'Carlos Bautista',
    driverInitials: 'CB',
    rating: 4.8,
    pickup: 'CMDI Bay Campus 1',
    destination: 'CMDI Main Campus Gate',
    seatsLeft: 8,
    departureTime: '7:30 AM',
    fare: 10.0,
  },
  {
    id: '6',
    vehicleType: 'Tricycle',
    vehicleModel: 'Honda Tricycle',
    driverName: 'Lito Manalo',
    driverInitials: 'LM',
    rating: 4.6,
    pickup: 'Bitin Junction',
    destination: 'CMDI Main Campus Gate',
    seatsLeft: 3,
    departureTime: '6:50 AM',
    fare: 15.0,
  },
];

app.get('/api/rides', (req, res) => {
  const { category, destination, pickup } = req.query;

  console.log(`[API] Fetching rides. Filters -> Category: ${category}, Pickup: ${pickup}, Dest: ${destination}`);

  let filtered = ALL_RIDES;

  if (category && category.toLowerCase() !== 'all') {
    filtered = filtered.filter((r) => r.vehicleType.toLowerCase() === category.toLowerCase());
  }
  if (pickup) {
    filtered = filtered.filter((r) => r.pickup.toLowerCase().includes(pickup.toLowerCase()));
  }
  if (destination) {
    filtered = filtered.filter((r) => r.destination.toLowerCase().includes(destination.toLowerCase()));
  }

  res.status(200).json({
    totalAvailable: filtered.length,
    rides: filtered,
  });
});

// ==========================================
// PANEL 7: VEHICLE DETAILS
// ==========================================
app.get('/api/rides/:id', (req, res) => {
  const { id } = req.params;
  const ride = ALL_RIDES.find((r) => r.id === id);

  if (!ride) return res.status(404).json({ success: false, error: `Ride '${id}' not found.` });

  res.status(200).json(ride);
});

// ==========================================
// PANEL 8: CONFIRM RIDE REQUEST
// ==========================================
app.post('/api/rides/request', (req, res) => {
  const { rideId, userId, pickup, destination, fare, departureTime } = req.body;

  if (!rideId) return res.status(400).json({ success: false, error: 'rideId is required.' });

  const ride = ALL_RIDES.find((r) => r.id === rideId);
  if (!ride) return res.status(404).json({ success: false, error: `Ride '${rideId}' not found.` });

  const bookingId = 'BOOK_' + Math.floor(100000 + Math.random() * 900000);
  const booking = {
    bookingId, rideId, userId: userId || 'anonymous',
    pickup: pickup || ride.pickup, destination: destination || ride.destination,
    driverName: ride.driverName, vehicleModel: ride.vehicleModel,
    fare: fare || ride.fare, departureTime: departureTime || ride.departureTime,
    status: 'Pending Driver Acceptance', requestedAt: new Date().toISOString(),
  };

  bookingsDb.set(bookingId, booking);
  res.status(200).json({ success: true, bookingId, message: 'Request submitted!', details: booking });
});

app.get('/api/rides/request/:bookingId', (req, res) => {
  const { bookingId } = req.params;
  const booking = bookingsDb.get(bookingId);
  if (!booking) return res.status(404).json({ success: false, error: `Booking '${bookingId}' not found.` });
  res.status(200).json({ success: true, booking });
});

// ==========================================
// 404 + ERROR HANDLERS
// ==========================================
app.use((req, res) => {
  console.log(`[404] Requested: ${req.originalUrl}`);
  res.status(404).json({ 
    success: false, 
    error: 'Endpoint not found. Check your API path.',
    requestedPath: req.originalUrl 
  });
});

app.use((err, req, res, next) => {
  console.error('[ERROR]', err);
  res.status(500).json({ success: false, error: 'Internal server error.', detail: err.message });
});

// ==========================================
// START SERVER
// ==========================================
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`ShareTrip backend server running on http://localhost:${PORT}`);
  console.log(`Try: http://localhost:${PORT}/health`);
});