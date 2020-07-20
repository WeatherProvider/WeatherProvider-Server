```
docker-compose build
gcloud config set project weather-provider

docker tag weatherprovider-server gcr.io/weather-provider/weatherprovider-server
docker push gcr.io/weather-provider/weatherprovider-server

gcloud config set run/region us-west1
gcloud run deploy weatherprovider-server \
    --image gcr.io/weather-provider/weatherprovider-server \
    --platform managed \
    --memory 512M \
    --allow-unauthenticated
```
