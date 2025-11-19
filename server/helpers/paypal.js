const paypal = require("paypal-rest-sdk");

paypal.configure({
  mode: "sandbox",
  client_id: "AYSevnchLE5xUIgt0p7oly_hcUi2qFasxT6mb7We6ADekr3SyTF2yIZH_n6J9rWwFar-w0fhD-VfJEVh",
  client_secret: "EGMGwyg0odJZNZ-hFz9kb4GDSMBFLG8QjOW_jlRdzJFxPrXaDtfhKM22VEcaCKQ2C0E9syE1NUJdn5_M",
});

module.exports = paypal;