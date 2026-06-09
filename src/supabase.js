import { createClient } from '@supabase/supabase-js'

const supabaseUrl = 'https://api.lionsssacademy.com.mx'
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlzcyI6InN1cGFiYXNlIiwiaWF0IjoxNzEwMDAwMDAwLCJleHAiOjIwMjYwMDAwMDB9._YcAXfm0orI7PqTfO7YJJq97tzwtA04vpFMGRo8jw-s'

export const supabase = createClient(supabaseUrl, supabaseKey)