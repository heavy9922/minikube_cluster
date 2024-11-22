$TTL 86400
@        IN  SOA my_server.devops.com. admin.devops.com. (
                202209000 ; Serial
                7200      ; Refresh
                3600      ; Retry
                1209600   ; Expire
                3600 )    ; Minimum TTL

@        IN  NS  my_server.devops.com.
;server
my_server  IN  A   172.168.30.80


;loadbalancer
lb-inlaze     IN  A   192.168.100.25

argocd	      IN  CNAME lb-inlaze

jenkins       IN  CNAME my_server
rancher       IN  CNAME my_server
