import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> sendFriendRequest(
    String currentUserId, String friendUserId) async {
  var friendSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(friendUserId)
      .get();
  var friendData = friendSnapshot.data()!;
  var friendUsername = friendData['username'];

  await FirebaseFirestore.instance.collection('friend_requests').add({
    'from': currentUserId,
    'to': friendUserId,
    'from_username': 'Your Username Here', // Fetch the current user's username
    'status': 'pending',
  });
}

Future<void> acceptFriendRequest(String requestId, String currentUserId,
    String friendUserId, String friendUsername) async {
  await FirebaseFirestore.instance
      .collection('friend_requests')
      .doc(requestId)
      .update({'status': 'accepted'});

  await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUserId)
      .collection('friends')
      .doc(friendUserId)
      .set({
    'uid': friendUserId,
    'username': friendUsername,
  });

  var currentUserSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUserId)
      .get();
  var currentUserData = currentUserSnapshot.data()!;
  var currentUsername = currentUserData['username'];

  await FirebaseFirestore.instance
      .collection('users')
      .doc(friendUserId)
      .collection('friends')
      .doc(currentUserId)
      .set({
    'uid': currentUserId,
    'username': currentUsername,
  });
}
