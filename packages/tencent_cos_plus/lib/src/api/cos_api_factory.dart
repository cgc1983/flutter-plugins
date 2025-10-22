import '../model/model.dart' show COSConfig;
import 'cos_abstract_api.dart';
import 'cos_bucket_api.dart';
import 'cos_object_api/cos_object_api.dart';

/// COSApi工厂类
/// 支持创建多个实例，每个实例管理自己的API集合和配置
class COSApiFactory {
  /// 默认的COSBucketApi键
  static final Symbol _keyCOSBucketApi = #keyCOSBucketApi;

  /// 默认的COSObjectApi键
  static final Symbol _keyCOSObjectApi = #keyCOSObjectApi;

  /// api集合
  final Map<Symbol, COSAbstractApi> _cosApis = <Symbol, COSAbstractApi>{};

  /// cos配置
  final COSConfig config;

  /// 构造函数
  /// [config] cos配置
  COSApiFactory({required this.config});

  /// 读取默认的COSBucketApi
  COSBucketApi get bucketApi => get<COSBucketApi>(_keyCOSBucketApi);

  /// 读取默认的COSObjectApi
  COSObjectApi get objectApi => get<COSObjectApi>(_keyCOSObjectApi);

  /// 初始化默认api
  /// [bucketName] 存储桶名称
  /// [region] 区域信息
  void initialize({required String bucketName, required String region}) {
    createBucketApi(_keyCOSBucketApi, bucketName, region);
    createObjectApi(_keyCOSObjectApi, bucketName, region);
  }

  /// 创建Api
  /// [key] 唯一标识
  /// [api] COSAbstractApi实例
  void createApi(Symbol key, COSAbstractApi api) {
    _cosApis[key] = api;
  }

  /// 创建BucketApi
  /// [key] 唯一标识
  /// [bucketName] 存储桶名称
  /// [region] 区域信息
  void createBucketApi(Symbol key, String bucketName, String region) {
    createApi(
      key,
      COSBucketApi(config, bucketName: bucketName, region: region),
    );
  }

  /// 创建ObjectApi
  /// [key] 唯一标识
  /// [bucketName] 存储桶名称
  /// [region] 区域信息
  void createObjectApi(Symbol key, String bucketName, String region) {
    createApi(
      key,
      COSObjectApi(config, bucketName: bucketName, region: region),
    );
  }

  /// 获取Api
  /// [key] 唯一标识
  T get<T extends COSAbstractApi>(Symbol key) {
    if (_cosApis.containsKey(key)) {
      return _cosApis[key]! as T;
    }
    throw Exception('$key is not exist, check it please');
  }
}
