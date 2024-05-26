import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> sendFriendRequest(
    String currentUserId, String friendUserId) async {
  DocumentReference friendRequestDoc =
      FirebaseFirestore.instance.collection('friend_requests').doc();
  await friendRequestDoc.set({
    'from': currentUserId,
    'to': friendUserId,
    'status': 'pending',
  });
}

Future<void> acceptFriendRequest(
    String requestId, String currentUserId, String friendUserId) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUserId)
      .update({
    'friends': FieldValue.arrayUnion([friendUserId])
  });

  await FirebaseFirestore.instance
      .collection('users')
      .doc(friendUserId)
      .update({
    'friends': FieldValue.arrayUnion([currentUserId])
  });

  await FirebaseFirestore.instance
      .collection('friend_requests')
      .doc(requestId)
      .update({
    'status': 'accepted',
  });
}
