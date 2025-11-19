// server/verifyUpdate.js
require('dotenv').config();
const mongoose = require('mongoose');
const User = require('./models/User');

(async () => {
  try {
    const uri = process.env.MONGO_URI || '';
    console.log('MONGO_URI present?', !!uri);
    console.log('MONGO_URI preview:', uri ? uri.slice(0, 160) : '(empty)');

    await mongoose.connect(uri, { useNewUrlParser: true, useUnifiedTopology: true });

    // change this filter if you identify user by email instead of userName
    const filter = { email: '123@gmail.com' };

    const user = await User.findOne(filter).lean();
    if (!user) {
      console.log('No user found with filter:', filter);
    } else {
      console.log('User document retrieved from DB:');
      console.log(JSON.stringify(user, null, 2));
      // show password preview
      console.log('password_preview:', user.password ? user.password.slice(0, 16) + '...' : null);
    }

    await mongoose.disconnect();
    process.exit(0);
  } catch (err) {
    console.error('ERROR:', err);
    try { await mongoose.disconnect(); } catch(e) {}
    process.exit(1);
  }
})();
