const StreamChat = require('stream-chat').StreamChat;
const AppleAuth = require('apple-auth');
const express = require('express');
const storage = require('node-persist');
const jwt = require('jsonwebtoken');

const apiKey = '[apiKey]';
const serverKey = '[serverKey]';
const streamClient = new StreamChat(apiKey, serverKey);

const appleAuth = new AppleAuth({
  client_id: "[client_id]",
  team_id: "[team_id]",
  key_id: "[key_id]",
  scope: "name email"
}, './config/AuthKey.p8');

storage.init();

const app = express();
app.use(express.json());

app.post('/authenticate', async (req, res) => {
  const {appleUid, appleAuthCode, name} = req.body;
  console.log(`[INFO] Sign in attempt with request: ${JSON.stringify(req.body)}`);

  let email;
  try {
    const response = await appleAuth.accessToken(appleAuthCode);
    email = jwt.decode(response.id_token).email;
    console.log(`[INFO] User identity confirmed by Apple.`);
  } catch {
    console.log(`[ERROR] Could not confirm user identity with Apple.`);
    res.sendStatus(401);
    return;
  }

  if(email && name) {
    const streamId = Buffer.from(email).toString('base64').replace(/=/g, '@');
    const userData = {streamId, email, name};
    await storage.set(appleUid, userData);
    console.log(`[INFO] User registered with email: ${email}. Derived streamId: ${streamId}`);
  }

  const userData = await storage.get(appleUid);

  if (!userData) {
    console.log(`[ERROR] User not found in persistent storage.`);
    res.sendStatus(404);
    return;
  }

  const response = {
    apiKey,
    streamId: userData.streamId,
    streamToken: streamClient.createToken(userData.streamId),
    email: userData.email,
    name: userData.name
  };

  console.log(`[INFO] User signed in successfully with response: ${JSON.stringify(response)}.`);

  res.send(response);
});

const port = process.env.PORT || 4000;
app.listen(port);
console.log(`Running on port ${port}`);
