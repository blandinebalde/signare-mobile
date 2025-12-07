class Task {
  final int? id;
  final String title;
  final String? description;
  final DateTime scheduledDate;
  final DateTime? dueDate;
  final String status; // PENDING, IN_PROGRESS, COMPLETED, CANCELLED
  final String priority; // LOW, MEDIUM, HIGH, URGENT
  final int? assignedToId;
  final String? assignedToUsername;
  final String? assignedToName;
  final int? createdById;
  final String? createdByUsername;
  final String? category;
  final int? entrepotId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;
  final bool? isOverdue;

  Task({
    this.id,
    required this.title,
    this.description,
    required this.scheduledDate,
    this.dueDate,
    required this.status,
    required this.priority,
    this.assignedToId,
    this.assignedToUsername,
    this.assignedToName,
    this.createdById,
    this.createdByUsername,
    this.category,
    this.entrepotId,
    this.createdAt,
    this.updatedAt,
    this.completedAt,
    this.isOverdue,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int?,
      title: json['title'] as String,
      description: json['description'] as String?,
      scheduledDate: DateTime.parse(json['scheduledDate'] as String),
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      status: json['status'] as String? ?? 'PENDING',
      priority: json['priority'] as String? ?? 'MEDIUM',
      assignedToId: json['assignedToId'] as int?,
      assignedToUsername: json['assignedToUsername'] as String?,
      assignedToName: json['assignedToName'] as String?,
      createdById: json['createdById'] as int?,
      createdByUsername: json['createdByUsername'] as String?,
      category: json['category'] as String?,
      entrepotId: json['entrepotId'] as int?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      isOverdue: json['isOverdue'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'scheduledDate': scheduledDate.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'status': status,
      'priority': priority,
      'assignedToId': assignedToId,
      'category': category,
      'entrepotId': entrepotId,
    };
  }
}

