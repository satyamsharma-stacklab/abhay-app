const mongoose = require('mongoose');

// Ek learning topic. Status (completed/locked) yahan nahi hai,
// wo user ke progress se aayega (Part 11).
const topicSchema = new mongoose.Schema(
  {
    id: { type: String, required: true, unique: true, trim: true },
    title: { type: String, required: true, trim: true },
    order: { type: Number, required: true },
    playable: { type: Boolean, default: false },
  },
  // Hamara apna "id" field hai, isliye Mongoose ka automatic id band.
  { id: false, versionKey: false }
);

module.exports = mongoose.model('Topic', topicSchema);