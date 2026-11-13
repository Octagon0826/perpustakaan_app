
import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../core/routes/app_router.dart';

class BookCard extends StatelessWidget {
  final BookModel book;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BookCard({
    super.key,
    required this.book,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(book.id.toString()),
        ),
        title: Text(
          book.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${book.author} · ${book.publishedYear} · Stok: ${book.stock}',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
              tooltip: 'Edit',
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
              tooltip: 'Hapus',
            ),
          ],
        ),
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutes.bookDetail,
          arguments: book,
        ),
      ),
    );
  }
}
