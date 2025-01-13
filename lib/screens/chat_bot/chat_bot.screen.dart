import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:viovid_app/base/assets.dart';
import 'package:viovid_app/features/chat_bot/cubit/chat_bot_cubit.dart';
import 'package:viovid_app/features/chat_bot/cubit/chat_bot_state.dart';
import 'package:viovid_app/features/chat_bot/dtos/message.dart';
import 'package:viovid_app/features/user_profile/cubit/user_profile_cutbit.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({super.key});

  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  bool _isProcessing = false;
  bool _isClearingThread = false;

  XFile? _selectedImage;

  late final userProfile = context.watch<UserProfileCubit>().state.userProfile!;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (userProfile.threadId != null) {
        log('userProfile.threadId != null');
        context.read<ChatBotCubit>().getMessages(userProfile.threadId!);
      }
    });
  }

  void handleSubmitMessage() async {
    final message = _controller.text;
    if (message.isEmpty) {
      _focusNode.requestFocus();
      return;
    }
    _focusNode.unfocus();
    _controller.clear(); // Xóa nội dung trong TextField

    setState(() {
      _isProcessing = true;
    });

    if (userProfile.threadId == null) {
      final threadId = await context.read<ChatBotCubit>().createThread();
      if (threadId != null) {
        await context.read<UserProfileCubit>().updateThreadId(threadId);
      }
    }

    Uint8List? imageBytes;
    String? fileId;
    if (_selectedImage != null) {
      fileId = await context
          .read<ChatBotCubit>()
          .uploadFileToStorage(_selectedImage!);
      if (fileId != null) {
        imageBytes =
            await context.read<ChatBotCubit>().getFileFromStorage(fileId);
      }
    }

    _selectedImage = null;

    context.read<ChatBotCubit>().updateMessages(
      [
        ...context.read<ChatBotCubit>().state.messages,
        if (imageBytes != null)
          Message(
            content: imageBytes,
            isUserMessage: true,
            type: MessageType.image,
          ),
        Message(
          content: message,
          isUserMessage: true,
          type: MessageType.text,
        ),
        Message(
          content: '🤖 đang trả lời ...',
          isUserMessage: false,
          type: MessageType.text,
        ),
      ],
    );

    // TODO: Cuộn xuống cuối SAU khi thêm item

    final messageId = await context.read<ChatBotCubit>().addMessageToThread(
          userProfile.threadId!,
          message,
          fileId,
        );

    if (messageId != null) {
      final runId =
          await context.read<ChatBotCubit>().createRun(userProfile.threadId!);
      if (runId != null) {
        // Lấy ra message mới nhất
        final message = await context
            .read<ChatBotCubit>()
            .getLastThreadMessages(userProfile.threadId!);
        //
        _isProcessing = false;
        final messages = [...context.read<ChatBotCubit>().state.messages];
        messages.removeLast();
        //
        if (message != null) {
          messages.add(message);
        } else {
          messages.add(
            Message(
              content:
                  'Có lỗi xảy ra trong khi tạo câu trả lời. :((\nVui lòng thử lại.',
              isUserMessage: false,
              type: MessageType.text,
            ),
          );
        }
        //
        context.read<ChatBotCubit>().updateMessages(messages);
      }
    }

    setState(() {
      _isProcessing = false;
    });
  }

  void clearChatHistory() async {
    setState(() {
      _isClearingThread = true;
    });
    final deleted = await context
        .read<ChatBotCubit>()
        .clearChatHistory(userProfile.threadId!);
    if (deleted) {
      await context.read<UserProfileCubit>().updateThreadId(null);
    }
    setState(() {
      _isClearingThread = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBotCubit, ChatBotState>(
      listener: (ctx, state) {},
      builder: (ctx, state) {
        Widget child;
        if (state.isLoading) {
          child = _buildInProgressChatBotWidget();
        } else if (state.errorMessage.isNotEmpty) {
          child = _buildFailureChatBotWidget(state.errorMessage);
        } else {
          child = _buildChatBotWidget(state);
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('VioVid Assistant 🤖'),
            actions: [
              if (userProfile.threadId != null)
                _isClearingThread
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white30,
                            strokeWidth: 3,
                          ),
                        ),
                      )
                    : IconButton(
                        onPressed: clearChatHistory,
                        icon: const Icon(Icons.playlist_remove_rounded),
                        style: IconButton.styleFrom(
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
            ],
          ),
          body: child,
        );
      },
    );
  }

  Widget _buildInProgressChatBotWidget() {
    return const Center(
      child: Column(
        spacing: 14,
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          Text(
            'Đang tải dữ liệu',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFailureChatBotWidget(String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Text(
          errorMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildChatBotWidget(ChatBotState state) {
    bool isBlock = _isProcessing || _isClearingThread;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        children: [
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              return SingleChildScrollView(
                controller: _scrollController,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: userProfile.threadId == null
                        ? constraints.maxHeight
                        : 0,
                  ),
                  child: Column(
                    mainAxisAlignment: userProfile.threadId == null
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.start,
                    children: userProfile.threadId == null
                        ? [
                            Image.asset(
                              Assets.viovidAssistantBot,
                              height: 120,
                            ),
                            const Gap(16),
                            const Text(
                              'Bạn cần trợ giúp ư\nHãy trò chuyện với tôi nhé!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Gap(50),
                          ]
                        : [
                            ...state.messages.map(
                              (message) => Align(
                                alignment: message.isUserMessage
                                    ? Alignment.centerRight
                                    : Alignment.bottomLeft,
                                child: message.type == MessageType.text
                                    ? Container(
                                        constraints:
                                            const BoxConstraints(maxWidth: 350),
                                        decoration: BoxDecoration(
                                          color: message.isUserMessage
                                              ? const Color(0xFF3F3F3F)
                                              : Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Text(
                                          message.content,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    : Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: Image.memory(
                                            message.content,
                                            width: 120,
                                            height: 120,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                              ),
                            ),
                          ],
                  ),
                ),
              );
            }),
          ),
          const Gap(12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton.filled(
                onPressed: isBlock
                    ? null
                    : () async {
                        final XFile? pickedImage = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        setState(() {
                          _selectedImage = pickedImage;
                        });
                      },
                icon: const Icon(Icons.image_outlined),
                style: IconButton.styleFrom(
                  fixedSize: const Size(58, 58),
                  foregroundColor: Colors.white.withOpacity(0.7),
                  backgroundColor: const Color(0xFF3F3F3F),
                  disabledForegroundColor: Colors.white.withOpacity(0.7),
                  disabledBackgroundColor: const Color(0xFF3F3F3F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const Gap(8),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: const Color(0xFF3F3F3F),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_selectedImage != null) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.file(
                                  File(_selectedImage!.path),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: -6,
                                right: -6,
                                child: IconButton(
                                  onPressed: () => setState(() {
                                    _selectedImage = null;
                                  }),
                                  icon: const Icon(Icons.clear_rounded),
                                  style: IconButton.styleFrom(
                                    iconSize: 20,
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.black54,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                      TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        style: const TextStyle(color: Colors.white),
                        enabled: !isBlock,
                        decoration: InputDecoration(
                          hintText: 'Tin nhắn ...',
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                          ),
                          border: MaterialStateOutlineInputBorder.resolveWith(
                            (states) {
                              if (states.contains(WidgetState.focused)) {
                                return const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide:
                                      BorderSide(color: Colors.amber, width: 2),
                                );
                              } else if (states.contains(WidgetState.hovered)) {
                                return const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                  borderSide:
                                      BorderSide(color: Colors.amber, width: 1),
                                );
                              }
                              return const OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              );
                            },
                          ),
                          contentPadding:
                              const EdgeInsets.fromLTRB(14, 17, 14, 17),
                        ),
                        onEditingComplete: handleSubmitMessage,
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(8),
              IconButton(
                onPressed: isBlock ? null : handleSubmitMessage,
                // icon: const Icon(Icons.arrow_upward_rounded),
                icon: _isProcessing
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Icon(Icons.arrow_upward_rounded),
                style: IconButton.styleFrom(
                  fixedSize: const Size(58, 58),
                  foregroundColor: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor,
                  disabledForegroundColor: Colors.black,
                  disabledBackgroundColor: const Color(0xFF676767),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              )
            ],
          ),
          const Gap(8),
        ],
      ),
    );
  }
}
