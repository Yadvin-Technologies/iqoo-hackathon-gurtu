'use strict';

class BadRequest extends Error {
  constructor(field, reason = 'invalid') {
    super(`${field}: ${reason}`);
    this.field = field;
    this.reason = reason;
  }
}

function text(value, field, { max = 200, required = false } = {}) {
  if (value === undefined || value === null || value === '') {
    if (required) throw new BadRequest(field, 'required');
    return '';
  }
  if (typeof value !== 'string') throw new BadRequest(field);
  const trimmed = value.trim();
  if (required && !trimmed) throw new BadRequest(field, 'required');
  if (trimmed.length > max) throw new BadRequest(field, 'too_long');
  return trimmed;
}

function oneOf(value, field, allowed, { required = false, fallback = null } = {}) {
  if (value === undefined || value === null || value === '') {
    if (required) throw new BadRequest(field, 'required');
    return fallback;
  }
  if (!allowed.includes(value)) throw new BadRequest(field);
  return value;
}

function int(value, field, { min, max } = {}) {
  if (value === undefined || value === null) return null;
  if (!Number.isInteger(value) || value < min || value > max) throw new BadRequest(field);
  return value;
}

function list(value, field, { max = 30, itemMax = 40 } = {}) {
  if (value === undefined || value === null) return [];
  if (!Array.isArray(value) || value.length > max) throw new BadRequest(field);
  return value.map((v, i) => text(v, `${field}[${i}]`, { max: itemMax, required: true }));
}

const ROLES = ['patient', 'caregiver', 'family', 'helper'];

/** The onboarding answers, as enum names (the app keeps display text out). */
function patientProfile(p) {
  if (!p || typeof p !== 'object') throw new BadRequest('patient', 'required');
  return {
    name: text(p.name, 'patient.name', { max: 60, required: true }),
    age: int(p.age, 'patient.age', { min: 0, max: 120 }),
    gender: text(p.gender, 'patient.gender', { max: 20 }) || null,
    conditions: list(p.conditions, 'patient.conditions'),
    allergies: list(p.allergies, 'patient.allergies'),
    careFor: text(p.careFor, 'patient.careFor', { max: 20 }) || null,
    takesMedicines: text(p.takesMedicines, 'patient.takesMedicines', { max: 20 }) || null,
    medicineCount: text(p.medicineCount, 'patient.medicineCount', { max: 20 }) || null,
    mobility: text(p.mobility, 'patient.mobility', { max: 20 }) || null,
    recentHospitalVisit:
      text(p.recentHospitalVisit, 'patient.recentHospitalVisit', { max: 20 }) || null,
  };
}

module.exports = { BadRequest, text, oneOf, int, list, ROLES, patientProfile };
