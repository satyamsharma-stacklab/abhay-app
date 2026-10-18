const mongoose = require('mongoose');

// Simple email check: kuch@kuch.kuch (beech mein space nahi).
const EMAIL_PATTERN = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

// Ek user. Asli password kabhi save nahi hota, sirf passwordHash.
const userSchema = new mongoose.Schema(
  {
    name: { type: String, required: true, trim: true, maxlength: 50 },
    email: {
      type: String,
      required: true,
      unique: true,
      trim: true,
      lowercase: true,
      match: [EMAIL_PATTERN, 'Email sahi nahi hai'],
    },
    passwordHash: { type: String, required: true },
    createdAt: { type: Date, default: Date.now },
  },
  { versionKey: false }
);

// Bahar bhejne ka safe roop. passwordHash kabhi nahi jaata.
userSchema.methods.toPublic = function toPublic() {
  return {
    id: this._id.toString(),
    name: this.name,
    email: this.email,
    createdAt: this.createdAt,
  };
};

module.exports = mongoose.model('User', userSchema);