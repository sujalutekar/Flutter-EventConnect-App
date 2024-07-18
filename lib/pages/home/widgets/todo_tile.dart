// ignore_for_file: use_build_context_synchronously

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../constants/truncate_string.dart';
import '../../../models/todo.dart';

class TodoTile extends StatefulWidget {
  final Todo todo;

  const TodoTile({super.key, required this.todo});

  @override
  State<TodoTile> createState() => _TodoTileState();
}

class _TodoTileState extends State<TodoTile> {
  bool isExpanded = false;
  final TextEditingController priorityController = TextEditingController();
  final TextEditingController statusController = TextEditingController();

  @override
  void initState() {
    priorityController.text = widget.todo.priority!;
    statusController.text = widget.todo.status!;
    super.initState();
  }

  @override
  void dispose() {
    priorityController.dispose();
    statusController.dispose();
    super.dispose();
  }

  Future<int> checkPriorityNumber() async {
    if (priorityController.text == 'low') {
      return 1;
    } else if (priorityController.text == 'medium') {
      return 2;
    } else if (priorityController.text == 'high') {
      return 3;
    }

    return 0;
  }

  Future<void> saveTodo() async {
    try {
      final int priorityNumber = await checkPriorityNumber();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('todo')
          .doc(widget.todo.id)
          .update({
        'priority': priorityController.text,
        'status': statusController.text,
        'priorityNumber': priorityNumber,
      });

      setState(() {
        isExpanded = false;
      });

      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Todo updated successfully'),
        ),
      );
    } catch (e) {
      log(e.toString());
    }
  }

  void deleteButtonPressed() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Todo'),
          content: const Text('Are you sure you want to delete this todo?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();

                // show another dialog to confirm the delete
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      titleTextStyle: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                      title: const Text('Confirm Delete'),
                      content: const Text(
                          'This action cannot be undone. Are you sure you want to delete this todo?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            try {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection('todo')
                                  .doc(widget.todo.id)
                                  .delete();

                              Navigator.of(context).pop();

                              setState(() {
                                isExpanded = false;
                              });

                              ScaffoldMessenger.of(context)
                                  .hideCurrentMaterialBanner();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Todo deleted successfully'),
                                ),
                              );
                            } catch (e) {
                              log(e.toString());
                            }
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: GestureDetector(
        onTap: () {
          setState(() {
            isExpanded = !isExpanded;
            priorityController.text = widget.todo.priority!;
          });
        },
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.todo.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          truncateString(
                            text: widget.todo.description,
                            wordLimit: 16,
                          ),
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.priority_high,
                            ),
                            const SizedBox(width: 4),
                            if (widget.todo.priority == 'low')
                              const Text(
                                'Priority: Low',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            else if (widget.todo.priority == 'medium')
                              const Text(
                                'Priority: Medium',
                                style: TextStyle(
                                  color: Colors.yellow,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            else
                              const Text(
                                'Priority: High',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      if (widget.todo.status == 'completed')
                        const Icon(
                          Icons.check_circle,
                          size: 20,
                          color: Colors.green,
                        )
                      else
                        const Icon(
                          Icons.timelapse_rounded,
                          size: 20,
                          color: Colors.amber,
                        ),
                      const SizedBox(width: 4),
                      Text(
                        widget.todo.status!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: widget.todo.status == 'completed'
                              ? Colors.green
                              : Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (isExpanded)
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              DropdownMenu(
                                initialSelection: widget.todo.priority,
                                controller: priorityController,
                                label: const Text('Priority'),
                                onSelected: (value) {
                                  setState(() {
                                    priorityController.text = value!;
                                  });
                                },
                                dropdownMenuEntries: const [
                                  DropdownMenuEntry(value: 'low', label: 'low'),
                                  DropdownMenuEntry(
                                      value: 'medium', label: 'medium'),
                                  DropdownMenuEntry(
                                      value: 'high', label: 'high'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            const SizedBox(height: 20),
                            DropdownMenu(
                              initialSelection: widget.todo.status,
                              controller: statusController,
                              label: const Text('Status'),
                              onSelected: (value) {
                                setState(() {
                                  statusController.text = value!;
                                });
                              },
                              dropdownMenuEntries: const [
                                DropdownMenuEntry(
                                    value: 'pending', label: 'pending'),
                                DropdownMenuEntry(
                                    value: 'completed', label: 'completed'),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        // delete button
                        Expanded(
                          child: GestureDetector(
                            onTap: deleteButtonPressed,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 12),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (widget.todo.priority.toString() !=
                                priorityController.text.toString() ||
                            widget.todo.status.toString() !=
                                statusController.text.toString())
                          const SizedBox(
                            width: 8,
                          ),

                        // save button
                        if (widget.todo.priority.toString() !=
                                priorityController.text.toString() ||
                            widget.todo.status.toString() !=
                                statusController.text.toString())
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                await saveTodo();
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 12),
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Save',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        else
                          const SizedBox.shrink(),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
