// Express identifies error handlers by their four-argument signature, so `next` must stay.
// eslint-disable-next-line no-unused-vars
export const errorHandler = (config) => (err, req, res, next) => {
  const status = err.status ?? err.statusCode ?? 500;
  const isServerError = status >= 500;

  if (isServerError) {
    console.error(err);
  }

  res.status(status).json({
    error: {
      message: isServerError && config.isProduction ? 'Internal server error' : err.message,
      ...(!config.isProduction && isServerError && { stack: err.stack }),
    },
  });
};
