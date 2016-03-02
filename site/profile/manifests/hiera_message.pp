class profile::hiera_message (
  $message = 'hello'
  ){
  notify { $message: }
}
