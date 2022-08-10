extension WithoutMapExtension<K, V> on Map<K, V> {
  Map<K, V> without(K key) => {...this}..remove(key);
}
