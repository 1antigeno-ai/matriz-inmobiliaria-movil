/*
  # Appointments Management System

  ## Overview
  This migration creates a complete appointments management system with proper security.

  ## 1. New Tables
    
  ### `appointments`
  - `id` (uuid, primary key) - Unique identifier for each appointment
  - `full_name` (text) - Client's full name
  - `phone_number` (text) - Client's phone number
  - `email` (text) - Client's email address
  - `document_type` (text) - Type of identification document (CC, TI, CE, Passport)
  - `document_number` (text) - Identification document number
  - `appointment_date` (date) - Date of the appointment
  - `appointment_time` (time) - Time of the appointment
  - `service` (text) - Type of service requested
  - `details` (text) - Additional details about the appointment
  - `status` (text) - Current status (programada, confirmada, completada, cancelada)
  - `created_at` (timestamptz) - Timestamp when appointment was created
  - `updated_at` (timestamptz) - Timestamp when appointment was last updated
  - `user_id` (uuid) - Reference to the user who created the appointment

  ## 2. Security
    - Enable RLS on `appointments` table
    - Add policies for authenticated users to manage their own appointments
    - Only authenticated users can create, read, update, and delete appointments

  ## 3. Indexes
    - Index on `appointment_date` for efficient date filtering
    - Index on `status` for efficient status filtering
    - Index on `user_id` for efficient user-specific queries
*/

-- Create appointments table
CREATE TABLE IF NOT EXISTS appointments (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  full_name text NOT NULL,
  phone_number text NOT NULL,
  email text NOT NULL,
  document_type text NOT NULL CHECK (document_type IN ('CC', 'TI', 'CE', 'Pasaporte')),
  document_number text NOT NULL,
  appointment_date date NOT NULL,
  appointment_time time NOT NULL,
  service text NOT NULL,
  details text DEFAULT '',
  status text NOT NULL DEFAULT 'programada' CHECK (status IN ('programada', 'confirmada', 'completada', 'cancelada')),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_appointments_date ON appointments(appointment_date);
CREATE INDEX IF NOT EXISTS idx_appointments_status ON appointments(status);
CREATE INDEX IF NOT EXISTS idx_appointments_user_id ON appointments(user_id);
CREATE INDEX IF NOT EXISTS idx_appointments_date_status ON appointments(appointment_date, status);

-- Enable Row Level Security
ALTER TABLE appointments ENABLE ROW LEVEL SECURITY;

-- Create policies for appointments
CREATE POLICY "Users can view their own appointments"
  ON appointments FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can create appointments"
  ON appointments FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own appointments"
  ON appointments FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own appointments"
  ON appointments FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Create function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_appointments_updated_at
  BEFORE UPDATE ON appointments
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();