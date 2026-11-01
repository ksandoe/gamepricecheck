import { z } from 'zod';

const envSchema = z.object({
  NODE_ENV: z.enum(['development', 'test', 'production']).default('development'),
  PORT: z.coerce.number().int().positive().default(3000),
  // Comma-separated list of origins allowed to call the API.
  CORS_ORIGIN: z.string().default('http://localhost:5173'),
  RATE_LIMIT_PER_MINUTE: z.coerce.number().int().positive().default(120),
  SUPABASE_URL: z.url().optional(),
  SUPABASE_SERVICE_ROLE_KEY: z.string().min(1).optional(),
});

export function loadConfig(env = process.env) {
  const parsed = envSchema.safeParse(env);
  if (!parsed.success) {
    throw new Error(`Invalid environment configuration:\n${z.prettifyError(parsed.error)}`);
  }

  const config = parsed.data;
  return {
    nodeEnv: config.NODE_ENV,
    isProduction: config.NODE_ENV === 'production',
    port: config.PORT,
    corsOrigins: config.CORS_ORIGIN.split(',').map((origin) => origin.trim()),
    rateLimitPerMinute: config.RATE_LIMIT_PER_MINUTE,
    supabaseUrl: config.SUPABASE_URL,
    supabaseServiceRoleKey: config.SUPABASE_SERVICE_ROLE_KEY,
  };
}
