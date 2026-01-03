import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agora/auth/cubits/cubits.dart';

enum AvatarSize {
  small,
  medium,
  large,
  extraLarge;

  double get toRadius => switch (this) {
    AvatarSize.small => 12,
    AvatarSize.medium => 16,
    AvatarSize.large => 20,
    AvatarSize.extraLarge => 24,
  };

  double get toIconSizePx => switch (this) {
    AvatarSize.small => 24,
    AvatarSize.medium => 32,
    AvatarSize.large => 40,
    AvatarSize.extraLarge => 48,
  };
}

class SessionAvatar extends StatelessWidget {
  const SessionAvatar({super.key, this.size = AvatarSize.medium});

  final AvatarSize size;

  @override
  Widget build(BuildContext context) {
    final iconPerson = Icon(Icons.person, size: size.toIconSizePx);
    return BlocBuilder<SessionCubit, SessionState>(
      builder: (context, state) => switch (state) {
        Authenticated(:final user) =>
          user.image != null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(user.image),
                  radius: size.toRadius,
                )
              : iconPerson,
        _ => iconPerson,
      },
    );
  }
}
