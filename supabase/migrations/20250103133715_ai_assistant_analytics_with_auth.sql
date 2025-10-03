-- Location: supabase/migrations/20250103133715_ai_assistant_analytics_with_auth.sql
-- Schema Analysis: Creating complete AI Assistant schema with analytics and authentication
-- Integration Type: NEW_MODULE - Complete system setup
-- Dependencies: Fresh schema implementation for AI assistant with call analytics

-- 1. Types and Enums
CREATE TYPE public.user_role AS ENUM ('admin', 'manager', 'user');
CREATE TYPE public.call_status AS ENUM ('incoming', 'outgoing', 'missed', 'answered', 'in_progress', 'completed', 'failed');
CREATE TYPE public.call_type AS ENUM ('voice', 'video', 'ai_assistant');
CREATE TYPE public.language_code AS ENUM ('en', 'hi', 'es', 'fr', 'de', 'it', 'pt', 'ru', 'ja', 'ko', 'zh');
CREATE TYPE public.subscription_plan AS ENUM ('free', 'premium', 'business', 'enterprise');

-- 2. Core User Profile Table (Critical intermediary)
CREATE TABLE public.user_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL UNIQUE,
    full_name TEXT NOT NULL,
    phone TEXT,
    role public.user_role DEFAULT 'user'::public.user_role,
    preferred_language public.language_code DEFAULT 'en'::public.language_code,
    subscription_plan public.subscription_plan DEFAULT 'free'::public.subscription_plan,
    is_active BOOLEAN DEFAULT true,
    profile_image_url TEXT,
    settings JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 3. Call Records Table (Main analytics data)
CREATE TABLE public.call_records (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    caller_name TEXT,
    caller_phone TEXT NOT NULL,
    call_type public.call_type DEFAULT 'ai_assistant'::public.call_type,
    call_status public.call_status NOT NULL,
    start_time TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    end_time TIMESTAMPTZ,
    duration INTEGER, -- in seconds
    transcript TEXT,
    summary TEXT,
    ai_confidence_score DECIMAL(3,2), -- 0.00 to 1.00
    recording_url TEXT,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 4. Analytics Table (Aggregated data)
CREATE TABLE public.call_analytics (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    total_calls INTEGER DEFAULT 0,
    successful_calls INTEGER DEFAULT 0,
    missed_calls INTEGER DEFAULT 0,
    total_duration INTEGER DEFAULT 0, -- in seconds
    average_duration DECIMAL(10,2) DEFAULT 0,
    ai_accuracy_score DECIMAL(3,2), -- 0.00 to 1.00
    peak_hours JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id, date)
);

-- 5. AI Assistant Settings
CREATE TABLE public.ai_assistant_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    voice_model TEXT DEFAULT 'alloy',
    language public.language_code DEFAULT 'en'::public.language_code,
    response_style TEXT DEFAULT 'professional',
    auto_answer BOOLEAN DEFAULT false,
    recording_enabled BOOLEAN DEFAULT true,
    transcript_enabled BOOLEAN DEFAULT true,
    custom_prompts JSONB DEFAULT '{}',
    forwarding_rules JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(user_id)
);

-- 6. Essential Indexes for Performance
CREATE INDEX idx_user_profiles_email ON public.user_profiles(email);
CREATE INDEX idx_user_profiles_role ON public.user_profiles(role);
CREATE INDEX idx_call_records_user_id ON public.call_records(user_id);
CREATE INDEX idx_call_records_caller_phone ON public.call_records(caller_phone);
CREATE INDEX idx_call_records_call_status ON public.call_records(call_status);
CREATE INDEX idx_call_records_start_time ON public.call_records(start_time DESC);
CREATE INDEX idx_call_analytics_user_date ON public.call_analytics(user_id, date DESC);
CREATE INDEX idx_call_analytics_date ON public.call_analytics(date DESC);
CREATE INDEX idx_ai_assistant_settings_user_id ON public.ai_assistant_settings(user_id);

-- 7. Functions (MUST BE BEFORE RLS POLICIES)
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO public.user_profiles (id, email, full_name, role)
  VALUES (
    NEW.id, 
    NEW.email, 
    COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
    COALESCE((NEW.raw_user_meta_data->>'role')::public.user_role, 'user'::public.user_role)
  );
  
  -- Create default AI assistant settings
  INSERT INTO public.ai_assistant_settings (user_id)
  VALUES (NEW.id);
  
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.update_call_analytics()
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
DECLARE
    call_date DATE;
    call_duration INTEGER;
    is_successful BOOLEAN;
BEGIN
    call_date := DATE(NEW.start_time);
    call_duration := COALESCE(NEW.duration, 0);
    is_successful := NEW.call_status IN ('completed', 'answered');

    INSERT INTO public.call_analytics (
        user_id, date, total_calls, successful_calls, 
        missed_calls, total_duration
    )
    VALUES (
        NEW.user_id, call_date, 1, 
        CASE WHEN is_successful THEN 1 ELSE 0 END,
        CASE WHEN NEW.call_status = 'missed' THEN 1 ELSE 0 END,
        call_duration
    )
    ON CONFLICT (user_id, date)
    DO UPDATE SET
        total_calls = call_analytics.total_calls + 1,
        successful_calls = call_analytics.successful_calls + 
            CASE WHEN is_successful THEN 1 ELSE 0 END,
        missed_calls = call_analytics.missed_calls + 
            CASE WHEN NEW.call_status = 'missed' THEN 1 ELSE 0 END,
        total_duration = call_analytics.total_duration + call_duration,
        average_duration = CASE 
            WHEN (call_analytics.total_calls + 1) > 0 
            THEN (call_analytics.total_duration + call_duration)::DECIMAL / (call_analytics.total_calls + 1)
            ELSE 0 
        END,
        updated_at = CURRENT_TIMESTAMP;

    RETURN NEW;
END;
$$;

-- 8. Enable RLS
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.call_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.call_analytics ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.ai_assistant_settings ENABLE ROW LEVEL SECURITY;

-- 9. RLS Policies (Pattern 1 for user_profiles, Pattern 2 for others)
-- Pattern 1: Core user table - simple, no functions
CREATE POLICY "users_manage_own_user_profiles"
ON public.user_profiles
FOR ALL
TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());

-- Pattern 2: Simple user ownership
CREATE POLICY "users_manage_own_call_records"
ON public.call_records
FOR ALL
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

CREATE POLICY "users_view_own_call_analytics"
ON public.call_analytics
FOR ALL
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

CREATE POLICY "users_manage_own_ai_settings"
ON public.ai_assistant_settings
FOR ALL
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

-- 10. Triggers
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

CREATE TRIGGER on_call_record_created
  AFTER INSERT OR UPDATE ON public.call_records
  FOR EACH ROW EXECUTE FUNCTION public.update_call_analytics();

-- 11. Mock Data for Testing (Complete auth.users structure)
DO $$
DECLARE
    admin_uuid UUID := gen_random_uuid();
    user1_uuid UUID := gen_random_uuid();
    user2_uuid UUID := gen_random_uuid();
    call1_uuid UUID := gen_random_uuid();
    call2_uuid UUID := gen_random_uuid();
    call3_uuid UUID := gen_random_uuid();
BEGIN
    -- Create complete auth.users records
    INSERT INTO auth.users (
        id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
        created_at, updated_at, raw_user_meta_data, raw_app_meta_data,
        is_sso_user, is_anonymous, confirmation_token, confirmation_sent_at,
        recovery_token, recovery_sent_at, email_change_token_new, email_change,
        email_change_sent_at, email_change_token_current, email_change_confirm_status,
        reauthentication_token, reauthentication_sent_at, phone, phone_change,
        phone_change_token, phone_change_sent_at
    ) VALUES
        (admin_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'admin@aiassistant.com', crypt('admin123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Admin User", "role": "admin"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null),
        (user1_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'rajesh@example.com', crypt('password123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Rajesh Kumar", "role": "user"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null),
        (user2_uuid, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'priya@example.com', crypt('password123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Priya Singh", "role": "user"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null);

    -- Create sample call records
    INSERT INTO public.call_records (id, user_id, caller_name, caller_phone, call_type, call_status, start_time, end_time, duration, transcript, summary, ai_confidence_score) VALUES
        (call1_uuid, user1_uuid, 'John Doe', '+91 98765 43210', 'ai_assistant', 'completed', 
         CURRENT_TIMESTAMP - INTERVAL '2 hours', CURRENT_TIMESTAMP - INTERVAL '2 hours' + INTERVAL '5 minutes', 
         300, 'Hello, I need help with my order status...', 'Customer inquiry about order status, resolved successfully', 0.95),
        (call2_uuid, user1_uuid, 'Sarah Wilson', '+91 87654 32109', 'ai_assistant', 'completed',
         CURRENT_TIMESTAMP - INTERVAL '1 hour', CURRENT_TIMESTAMP - INTERVAL '1 hour' + INTERVAL '3 minutes',
         180, 'Can you help me reschedule my appointment?', 'Appointment rescheduling request handled', 0.92),
        (call3_uuid, user2_uuid, 'Mike Johnson', '+91 76543 21098', 'ai_assistant', 'missed',
         CURRENT_TIMESTAMP - INTERVAL '30 minutes', null, null, null, null, null);

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Foreign key error: %', SQLERRM;
    WHEN unique_violation THEN
        RAISE NOTICE 'Unique constraint error: %', SQLERRM;
    WHEN OTHERS THEN
        RAISE NOTICE 'Unexpected error: %', SQLERRM;
END $$;

-- 12. Helper Functions for Analytics
CREATE OR REPLACE FUNCTION public.get_user_analytics_summary(user_uuid UUID, days_back INTEGER DEFAULT 30)
RETURNS TABLE(
    total_calls BIGINT,
    successful_calls BIGINT,
    missed_calls BIGINT,
    total_duration BIGINT,
    average_duration DECIMAL,
    success_rate DECIMAL
)
LANGUAGE sql
STABLE
SECURITY DEFINER
AS $$
    SELECT 
        COALESCE(SUM(ca.total_calls), 0)::BIGINT as total_calls,
        COALESCE(SUM(ca.successful_calls), 0)::BIGINT as successful_calls,
        COALESCE(SUM(ca.missed_calls), 0)::BIGINT as missed_calls,
        COALESCE(SUM(ca.total_duration), 0)::BIGINT as total_duration,
        CASE 
            WHEN SUM(ca.total_calls) > 0 
            THEN ROUND(SUM(ca.total_duration)::DECIMAL / SUM(ca.total_calls), 2)
            ELSE 0 
        END as average_duration,
        CASE 
            WHEN SUM(ca.total_calls) > 0 
            THEN ROUND((SUM(ca.successful_calls)::DECIMAL / SUM(ca.total_calls) * 100), 2)
            ELSE 0 
        END as success_rate
    FROM public.call_analytics ca
    WHERE ca.user_id = user_uuid
    AND ca.date >= CURRENT_DATE - INTERVAL '1 day' * days_back;
$$;