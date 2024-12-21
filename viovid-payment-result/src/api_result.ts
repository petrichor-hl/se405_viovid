export interface ApiResult<T> {
  succeeded: boolean;
  result: T;
  errors: [];
}
