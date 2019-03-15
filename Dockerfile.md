docker build -t bt .
docker run --rm -itd --name=bt bt
docker exec -it bt bash
netstat -tln
docker stop bt
docker tag IMGID faryoung/bt:latest
docker login #faryoung:PWD
docker push faryoung/bt


docker run --name btt -p 8888:8888 -p 80:80 -p 443:443 -d -v btserver:/www -v ~/wwwroot:/www/wwwroot faryoung/bt:latest
docker exec -it btt /etc/init.d/bt default



docker tag btnp faryoung/btnp:latest
docker run --name btnp -p 8888:8888 -p 80:80 -p 443:443 -d -v btserver:/www -v ~/wwwroot:/www/wwwroot faryoung/btnp:latest
docker exec -it btnp /etc/init.d/bt default

docker push faryoung/btnp
