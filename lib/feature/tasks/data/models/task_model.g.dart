import 'package:hive/hive.dart';
import 'task_model.dart';

class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 0;

  @override
  TaskModel read(BinaryReader reader) {
    return TaskModel(
      id: reader.readString(),
      title: reader.readString(),
      completed: reader.readBool(),
      isSynced: reader.readBool(),
      updatedAt:
          DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeBool(obj.completed);
    writer.writeBool(obj.isSynced);
    writer.writeInt(obj.updatedAt.millisecondsSinceEpoch);
  }
}
