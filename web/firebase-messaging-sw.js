importScripts("https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js");

// Initialize Firebase in the service worker
firebase.initializeApp({
    apiKey: 'AIzaSyCekF29VJvdg1bxl_p1X0qnZzfNK9431sc',
    authDomain: 'visionintelligence-481d8.firebaseapp.com',
    projectId: 'visionintelligence-481d8',
    storageBucket: 'visionintelligence-481d8.firebasestorage.app',
    messagingSenderId: '523746350716',
    appId: '1:523746350716:web:a1333d36f9c3a541ad9bf9'
});

// Retrieve an instance of Firebase Messaging
const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
    console.log("Received background message ", payload);

    const notificationTitle = payload.notification.title;
    const notificationOptions = {
        body: payload.notification.body,
        icon: "/firebase-logo.png"
    };

    self.registration.showNotification(notificationTitle, notificationOptions);
});
