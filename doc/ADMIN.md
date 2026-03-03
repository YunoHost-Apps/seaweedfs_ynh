The admin URL is <https://__DOMAIN____PATH__admin> and is available only to users in the admins group.  

### Credentials

:key: Admin credentials for __ADMIN__ :  
```
AWS_ACCESS_KEY_ID=__ADMIN_KEY__  
AWS_SECRET_ACCESS_KEY=__ADMIN_SECRET__
```

Additional credentials can be created via the SeaweedFS admin panel.

### Volume servers

The data directory for the default volume server is located at `/home/yunohost.app/seaweedfs/datadir`.  
Additional data directories can be added by creating additional volume servers via the configuration panel.

### Bucket creation
Buckets can be created using either `path_style` or `virtual_host` access.
With `virtual_host`:  
* add a domain named `<bucket_name>.__DOMAIN__`
* Install the [Redirect App](https://apps.yunohost.org/app/redirect) (`redirect_ynh`) at the root of this domain and configure it in `reverse_proxy` mode to point to `http://127.0.0.1:__PORT_API__ `
___
### Examples of use (Restic, Backrest, Nextcloud, Peertube)
#### Restic
* Install restic app with `s3:https://__DOMAIN__/<bucket_name>` as repository.
* In **Advanced configuration**, add the following credentials
```
AWS_ACCESS_KEY_ID=__ADMIN_KEY__
AWS_SECRET_ACCESS_KEY=__ADMIN_SECRET__
``` 
> Alternative via CLI
> * Open restic shell via CLI with `yunohost app shell restic`
> * `export AWS_ACCESS_KEY_ID=__ADMIN_KEY__`
> * `export AWS_SECRET_ACCESS_KEY=__ADMIN_SECRET__`
> * Initialize repository : `./restic -r s3:https://__DOMAIN__/<bucket_name> init` then exit.
* Start backup via webadmin or CLI.
#### Backrest  
* Repo URI : s3:https://__DOMAIN__/<bucket_name>
* Env vars:
```
AWS_ACCESS_KEY_ID=__ADMIN_KEY__  
AWS_SECRET_ACCESS_KEY=__ADMIN_SECRET__
```
#### Nextcloud
Admin settings > Add External storage > S3 Storage > Key access  
* choose a bucket name
* set as endpoint URL : __DOMAIN__
* tick `Active pathstyle`
* Key id : `__ADMIN_KEY__`
* Secret key: `__ADMIN_SECRET__`
#### Peertube
* Edit `/var/www/peertube/config/production.yaml` :
  - path_style version
```
object_storage:
  enabled: true
  force_path_style: true

  endpoint: '__DOMAIN__'
  credentials:
    # You can also use AWS_ACCESS_KEY_ID env variable
    access_key_id: '`__ADMIN_KEY__`'
    # You can also use AWS_SECRET_ACCESS_KEY env variable
    secret_access_key: '`__ADMIN_SECRET__`'

  streaming_playlists:
    # Bucket name created on your object storage provider
    # PeerTube will access it via {bucket_name}.example.com
    bucket_name: '<bucket_name>'

    # Allows setting all buckets to the same value but with a different prefix
    prefix: '<bucket_name>/streaming-playlists/'

    # Base url for object URL generation, scheme and host will be replaced by this URL
    # Useful when you want to use a CDN/external proxy
    base_url: '' # Example: 'https://mirror.example.com'

    # PeerTube makes many small requests to the object storage provider to upload/delete/update live chunks
    # which can be a problem depending on your object storage provider
    # You can also choose to disable this feature to reduce live streams latency
    # Live stream replays are not affected by this setting, so they are uploaded in object storage as regular VOD videos
    store_live_streams: false

  web_videos:
    bucket_name: '<bucket_name>'
    prefix: '<bucket_name>/web-videos/'
    base_url: ''

  user_exports:
    bucket_name: '<bucket_name>'
    prefix: '<bucket_name>/user-exports/'
    base_url: ''

  # Same settings but for original video files
  original_video_files:
    bucket_name: '<bucket_name>'
    prefix: '<bucket_name>/original-video-files/'
    base_url: ''

  # Video captions
  captions:
    bucket_name: '<bucket_name>'
    prefix: '<bucket_name>/captions/'
    base_url: ''

```
* systemctl restart peertube

  - virtual_host version
```
object_storage:
  enabled: true
  force_path_style: false
  endpoint: '__DOMAIN__'

  credentials:
    # You can also use AWS_ACCESS_KEY_ID env variable
    access_key_id: '`__ADMIN_KEY__`'
    # You can also use AWS_SECRET_ACCESS_KEY env variable
    secret_access_key: '`__ADMIN_SECRET__`'

  streaming_playlists:
    # Bucket name created on your object storage provider
    # PeerTube will access it via {bucket_name}.example.com
    bucket_name: '<bucket_name>'

    # Allows setting all buckets to the same value but with a different prefix
    prefix: 'streaming-playlists/'

    # Base url for object URL generation, scheme and host will be replaced by this URL
    # Useful when you want to use a CDN/external proxy
    base_url: '' # Example: 'https://mirror.example.com'

    # PeerTube makes many small requests to the object storage provider to upload/delete/update live chunks
    # which can be a problem depending on your object storage provider
    # You can also choose to disable this feature to reduce live streams latency
    # Live stream replays are not affected by this setting, so they are uploaded in object storage as regular VOD videos
    store_live_streams: false

  web_videos:
    bucket_name: '<bucket_name>'
    prefix: 'web-videos/'
    base_url: ''

  user_exports:
    bucket_name: '<bucket_name>'
    prefix: 'user-exports/'
    base_url: ''

  # Same settings but for original video files
  original_video_files:
    bucket_name: '<bucket_name>'
    prefix: 'original-video-files/'
    base_url: ''

  # Video captions
  captions:
    bucket_name: '<bucket_name>'
    prefix: 'captions/'
    base_url: ''

```
* systemctl restart peertube
