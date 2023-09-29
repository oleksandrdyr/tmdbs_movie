import 'package:flutter/material.dart';
import 'package:themoviedb/ui/theme/app_button_style.dart';
import 'package:themoviedb/ui/widgets/auth/auth_model.dart';
// import 'package:themoviedb/widgets/auth/auth_model.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Авторизация'),
        ),
        body: ListView(
          children: const [
            _HeaderWidget(),
          ],
        ));
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(fontSize: 16);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 25,
          ),
          const Text(
            'Войти в свою учётную запись',
            style: TextStyle(
              fontSize: 25,
              color: Color.fromRGBO(3, 37, 65, 1),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Чтобы пользоваться правкой и возможностями рейтинга TMDB, а также получить персональные рекомендации, необходимо войти в свою учётную запись. Если у вас нет учётной записи, её регистрация является бесплатной и простой.',
            style: textStyle,
          ),
          const SizedBox(height: 15),
          TextButton(
            style: AppButtonStyle.linkBUtton,
            onPressed: () {},
            child: const Text('Регистрация'),
          ),
          const SizedBox(height: 25),
          const Text(
            'Если Вы зарегистрировались, но не получили письмо для подтверждения.',
            style: textStyle,
          ),
          const SizedBox(height: 15),
          TextButton(
            style: AppButtonStyle.linkBUtton,
            onPressed: () {},
            child: const Text('Авторизация'),
          ),
          const SizedBox(height: 25),
          const _FormWidget(),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}

class _FormWidget extends StatelessWidget {
  const _FormWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final model = AuthModelProvider.read(context)?.model;

    const textStyle = TextStyle(fontSize: 16);
    const textFeildDecorator = InputDecoration(
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(255, 211, 192, 192))),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color.fromARGB(255, 229, 223, 223)),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      isCollapsed: true,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ErrorMessageWidget(),
        const SizedBox(height: 10),
        const Text('Имя пользователя', style: textStyle),
        const SizedBox(height: 5),
        // Text('${model?.errorMessage} '),
        TextField(
          controller: model?.loginTextController,
          decoration: textFeildDecorator,
        ),
        const SizedBox(height: 20),
        const Text('Пароль', style: textStyle),
        const SizedBox(height: 5),
        TextField(
          controller: model?.passwordTextController,
          obscureText: true,
          decoration: textFeildDecorator,
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            const _AuthButtonWidget(),
            const SizedBox(width: 30),
            TextButton(
              style: AppButtonStyle.linkBUtton,
              onPressed: () {},
              child: const Text('Сбросить пароль'),
            ),
          ],
        ),
      ],
    );
  }
}

class _AuthButtonWidget extends StatelessWidget {
  const _AuthButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = AuthModelProvider.watch(context)?.model;
    final child = model?.isAuthProgress == true
        ? const SizedBox(
            width: 10,
            height: 10,
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ))
        : const Text('Логин');
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(const Color(0xFF01B4E4)),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        textStyle: MaterialStateProperty.all(
          const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        padding: MaterialStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        ),
      ),
      onPressed:
          model?.canStartAuth == true ? () => model?.auth(context) : null,
      child: child,
    );
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  const _ErrorMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Получаем errorMessage и подписываемся на изменения
    final errorMessage = AuthModelProvider.watch(context)?.model.errorMessage;
    // Если нет, то возвращаем пустое место
    if (errorMessage == null) return const SizedBox.shrink();
    return Text(
      errorMessage,
      style: const TextStyle(
        color: Colors.red,
        fontSize: 20,
      ),
    );
  }
}
