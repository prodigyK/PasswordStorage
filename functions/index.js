const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.myFunction = functions.firestore
    .document('users/{userId}')
    .onWrite((change, context) => {
        const user = change.after.exists ? change.after.data() : null;
        const title = user == null ? 'User is Deleted:' : change.before.exists ? 'User is Updated' : 'User is Created';
        const body = user != null ? user.name : change.before.data().name;
        return admin.messaging().sendToTopic('passStore', {notification: {title: title, body: body}});
    });
