-- ============================================
-- WaSender Proxy via Supabase pg_net
-- Run this in Supabase SQL Editor
-- ============================================

-- Enable pg_net extension (HTTP requests from database)
CREATE EXTENSION IF NOT EXISTS pg_net WITH SCHEMA extensions;

-- Function to send WhatsApp message via WaSender
CREATE OR REPLACE FUNCTION send_whatsapp(
  p_phone text,
  p_message text
) RETURNS json
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
DECLARE
  v_request_id bigint;
  v_response json;
BEGIN
  SELECT net.http_post(
    url := 'https://api.wasender.net/v1/messages/send-text',
    headers := jsonb_build_object(
      'Content-Type', 'application/json',
      'Authorization', 'Bearer f56d0680ee5f69b96073c7714284a741d5b9c45d94bee3a5c4dd0cf8e54f9b7c',
      'Accept', 'application/json'
    ),
    body := jsonb_build_object(
      'sessionId', '73797',
      'to', p_phone || '@s.whatsapp.net',
      'text', p_message
    )
  ) INTO v_request_id;

  RETURN json_build_object('success', true, 'request_id', v_request_id);
EXCEPTION WHEN OTHERS THEN
  RETURN json_build_object('success', false, 'error', SQLERRM);
END;
$$;

-- Grant access
GRANT EXECUTE ON FUNCTION send_whatsapp(text, text) TO anon, authenticated, service_role;
