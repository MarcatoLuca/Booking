part of 'user_cubit.dart';

@immutable
abstract class UserState {
  const UserState();
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserNotConnected extends UserState {
  final String message;

  const UserNotConnected(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserNotConnected && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class UserLoading extends UserState {
  const UserLoading();
}

class UserAuthenticated extends UserState {
  final User user;
  const UserAuthenticated(this.user);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserAuthenticated && other.user == user;
  }

  @override
  int get hashCode => user.hashCode;
}

class UserNotAuthenicated extends UserState {
  final String message;
  const UserNotAuthenicated(this.message);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserNotAuthenicated && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}
