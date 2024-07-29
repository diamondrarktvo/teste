const path = require('path');

module.exports = {
  webpack: (config) => {
    config.module.rules.push({
      test: /\.(js|jsx|ts|tsx)$/,
      use: 'babel-loader',
      exclude: /node_modules/,
    });

    return config;
  },
  async rewrites() {
    return [
      {
        source: '/updates/:path*',
        destination: path.join(__dirname, 'updates/:path*'),
      },
    ];
  },
};
