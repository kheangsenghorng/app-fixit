class PusherChannels {
  static const categories = 'categories';
  static const types = 'types';
  static const services = 'services';
}

class PusherEvents {
  static const categoryChanged = 'category.changed';
  static const typeChanged = 'type.changed';
  static const serviceChanged = 'service.changed';
}

class PusherActions {
  static const created = 'created';
  static const updated = 'updated';
  static const deleted = 'deleted';
  static const restored = 'restored';
  static const forceDeleted = 'force_deleted';
}