L'URL de l'interface admin est <https://__DOMAIN____PATH__admin>. Seuls les utilisateurs du groupe __admins__ peuvent y accéder.  
L'adresse de l'API est <https://__DOMAIN____PATH__>.  



### Identifiants

:key: Un utilisateur admin __ADMIN__ est créé avec les clés suivantes  :  
```
AWS_ACCESS_KEY_ID=__ADMIN_KEY__  
AWS_SECRET_ACCESS_KEY=__ADMIN_SECRET__
``` 

D'autres utilisateurs peuvent être ajoutés via le panel admin de seaweedfs.

### Répertoires de données et pod `Volumes`
Le répertoire de données du premier pod volume est situé dans `/home/yunohost.app/seaweedfs/datadir`.  
D'autres répertoires peuvent être ajoutés via le panneau de configuration en créant de nouveaux pods volumes.  

###  Création des buckets  
Les buckets peuvent être créés en `path_style` ou `virtual_host`.  
> En `virtual_host`:  
> * il faut ajouter un domaine nommé `<bucket_name>.__DOMAIN__`
> * il faut ensuite installer l'app [Redirect App](https://apps.yunohost.org/app/redirect) (`redirect_ynh`) à la racine de ce domaine et la faire pointer en mode > `reverse_proxy` sur `http://127.0.0.1:__PORT_API__ `
___
### Exemples d'utilisation (Restic, Backrest, Nextcloud, Peertube)
#### Restic
* Installer l'app restic et choisir comme dépôt pour les sauvegardes `s3:https://__DOMAIN__/<bucket_name>`.
* Dans la partie **configuration avancée**, ajouter les identifiants :
```
AWS_ACCESS_KEY_ID=__ADMIN_KEY__
AWS_SECRET_ACCESS_KEY=__ADMIN_SECRET__
``` 
  
>  Alternative en ligne de commande:
> * ouvrir le shell restic:  `yunohost app shell restic`
> * `export AWS_ACCESS_KEY_ID=__ADMIN_KEY__`
> * `export AWS_SECRET_ACCESS_KEY=__ADMIN_SECRET__`
> * initialiser le dépôt : `./restic -r s3:https://__DOMAIN__/<bucket_name> init` puis sortir du shell (`exit).  
* démarrer la sauvegarde via la webadmin ou en ligne de commande.
#### Backrest
* URI du dépôt : s3:https://__DOMAIN__/<bucket_name>
* Variables d'environnement:
```
AWS_ACCESS_KEY_ID=__ADMIN_KEY__  
AWS_SECRET_ACCESS_KEY=__ADMIN_SECRET__
```
#### Nextcloud
Paramètres d'administration > Stockage externe > Stockage S3 > Clé d'accès.  
* nom du bucket
* endpoint URL : __DOMAIN__
* cocher `Active pathstyle`
* Key id : `__ADMIN_KEY__`
* Secret key: `__ADMIN_SECRET__`
#### Peertube
* Éditer `/var/www/peertube/config/production.yaml` :
  - version path_style
```
object_storage:
  enabled: true
  force_path_style: true

  endpoint: '__DOMAIN__'
  credentials:
    # You can also use AWS_ACCESS_KEY_ID env variable
    access_key_id: '__ADMIN_KEY__'
    # You can also use AWS_SECRET_ACCESS_KEY env variable
    secret_access_key: '__ADMIN_SECRET__'

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

  - version virtual_host
```
object_storage:
  enabled: true
  force_path_style: false
  endpoint: '__DOMAIN__'

  credentials:
    # You can also use AWS_ACCESS_KEY_ID env variable
    access_key_id: '__ADMIN_KEY__'
    # You can also use AWS_SECRET_ACCESS_KEY env variable
    secret_access_key: '__ADMIN_SECRET__'

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
* systemctl restart peertube.
