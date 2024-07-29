const ExpoConfig = require('@expo/config');
const path = require('path');

const projectName = process.argv[2];

const projectDir = path.join(__dirname, '..', '..', 'mobile', projectName);

const { exp } = ExpoConfig.getConfig(projectDir, {
  skipSDKVersionRequirement: true,
  isPublicConfig: true,
});

console.log(JSON.stringify(exp));
