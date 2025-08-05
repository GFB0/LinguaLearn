import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CommentsSectionWidget extends StatefulWidget {
  final List<Map<String, dynamic>> comments;
  final VoidCallback? onAddComment;

  const CommentsSectionWidget({
    super.key,
    required this.comments,
    this.onAddComment,
  });

  @override
  State<CommentsSectionWidget> createState() => _CommentsSectionWidgetState();
}

class _CommentsSectionWidgetState extends State<CommentsSectionWidget> {
  final TextEditingController _commentController = TextEditingController();
  final FocusNode _commentFocusNode = FocusNode();

  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.lightTheme.colorScheme.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'chat_bubble_outline',
                size: 24,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
              SizedBox(width: 2.w),
              Text(
                'Comentários e Dúvidas',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${widget.comments.length}',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _commentController,
                  focusNode: _commentFocusNode,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Faça uma pergunta ou compartilhe sua dúvida...',
                    border: InputBorder.none,
                    hintStyle:
                        AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        _commentController.clear();
                        _commentFocusNode.unfocus();
                      },
                      child: Text(
                        'Cancelar',
                        style:
                            AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    ElevatedButton(
                      onPressed: () {
                        if (_commentController.text.trim().isNotEmpty) {
                          widget.onAddComment?.call();
                          _commentController.clear();
                          _commentFocusNode.unfocus();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Comentário adicionado com sucesso!'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: Text('Comentar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          widget.comments.isEmpty
              ? Center(
                  child: Column(
                    children: [
                      CustomIconWidget(
                        iconName: 'chat_bubble_outline',
                        size: 48,
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                            .withValues(alpha: 0.5),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'Nenhum comentário ainda',
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        'Seja o primeiro a fazer uma pergunta!',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.comments.length,
                  separatorBuilder: (context, index) => SizedBox(height: 2.h),
                  itemBuilder: (context, index) {
                    final comment = widget.comments[index];
                    return _buildCommentItem(comment);
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(Map<String, dynamic> comment) {
    final userName = comment['userName'] as String;
    final userAvatar = comment['userAvatar'] as String;
    final content = comment['content'] as String;
    final timestamp = comment['timestamp'] as DateTime;
    final replies = (comment['replies'] as List?) ?? [];
    final isInstructor = comment['isInstructor'] as bool? ?? false;

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isInstructor
            ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05)
            : AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isInstructor
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.2)
              : AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(userAvatar),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          userName,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.lightTheme.colorScheme.onSurface,
                          ),
                        ),
                        if (isInstructor) ...[
                          SizedBox(width: 2.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Instrutor',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Text(
                      _formatTimestamp(timestamp),
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            content,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              height: 1.4,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Funcionalidade de curtir em breve!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: CustomIconWidget(
                  iconName: 'thumb_up_outlined',
                  size: 16,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                label: Text(
                  'Curtir',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Funcionalidade de responder em breve!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: CustomIconWidget(
                  iconName: 'reply',
                  size: 16,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
                label: Text(
                  'Responder',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          if (replies.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Container(
              margin: EdgeInsets.only(left: 4.w),
              padding: EdgeInsets.only(left: 3.w),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: replies.length,
                separatorBuilder: (context, index) => SizedBox(height: 1.h),
                itemBuilder: (context, index) {
                  return _buildReplyItem(
                      replies[index] as Map<String, dynamic>);
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReplyItem(Map<String, dynamic> reply) {
    final userName = reply['userName'] as String;
    final userAvatar = reply['userAvatar'] as String;
    final content = reply['content'] as String;
    final timestamp = reply['timestamp'] as DateTime;
    final isInstructor = reply['isInstructor'] as bool? ?? false;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 16,
          backgroundImage: NetworkImage(userAvatar),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    userName,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.colorScheme.onSurface,
                    ),
                  ),
                  if (isInstructor) ...[
                    SizedBox(width: 1.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 1.w, vertical: 0.2.h),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Instrutor',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Text(
                    _formatTimestamp(timestamp),
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 0.5.h),
              Text(
                content,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}min atrás';
    } else {
      return 'Agora';
    }
  }
}
