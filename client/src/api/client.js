const API_URL = import.meta.env.VITE_API_URL ?? '';

export class ApiError extends Error {
  constructor(message, status) {
    super(message);
    this.name = 'ApiError';
    this.status = status;
  }
}

export async function apiGet(path, params) {
  const query = params ? `?${new URLSearchParams(params)}` : '';
  const response = await fetch(`${API_URL}/api${path}${query}`);
  const body = await response.json().catch(() => null);

  if (!response.ok) {
    throw new ApiError(body?.error?.message ?? 'Request failed', response.status);
  }
  return body;
}
