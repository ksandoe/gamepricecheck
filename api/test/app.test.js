import { describe, expect, it } from 'vitest';
import express from 'express';
import request from 'supertest';
import { createApp } from '../src/app.js';
import { loadConfig } from '../src/config.js';
import { errorHandler } from '../src/middleware/errorHandler.js';

function appWith(env = {}) {
  return createApp(loadConfig({ NODE_ENV: 'test', ...env }));
}

describe('GET /api/health', () => {
  it('returns ok', async () => {
    const res = await request(appWith()).get('/api/health');
    expect(res.status).toBe(200);
    expect(res.body).toEqual({ status: 'ok' });
  });
});

describe('unknown routes', () => {
  it('return a JSON 404', async () => {
    const res = await request(appWith()).get('/api/nope');
    expect(res.status).toBe(404);
    expect(res.body.error.message).toMatch(/not found/i);
  });
});

describe('error handler', () => {
  function appThatThrows(env) {
    const app = express();
    app.get('/boom', () => {
      throw new Error('secret details');
    });
    app.use(errorHandler(loadConfig(env)));
    return app;
  }

  it('hides error details in production', async () => {
    const res = await request(appThatThrows({ NODE_ENV: 'production' })).get('/boom');
    expect(res.status).toBe(500);
    expect(res.body).toEqual({ error: { message: 'Internal server error' } });
  });

  it('includes the message outside production', async () => {
    const res = await request(appThatThrows({ NODE_ENV: 'development' })).get('/boom');
    expect(res.status).toBe(500);
    expect(res.body.error.message).toBe('secret details');
  });
});

describe('CORS', () => {
  it('allows the configured client origin', async () => {
    const res = await request(appWith({ CORS_ORIGIN: 'https://app.example' }))
      .get('/api/health')
      .set('Origin', 'https://app.example');
    expect(res.headers['access-control-allow-origin']).toBe('https://app.example');
  });

  it('does not allow other origins', async () => {
    const res = await request(appWith({ CORS_ORIGIN: 'https://app.example' }))
      .get('/api/health')
      .set('Origin', 'https://evil.example');
    expect(res.headers['access-control-allow-origin']).toBeUndefined();
  });
});
