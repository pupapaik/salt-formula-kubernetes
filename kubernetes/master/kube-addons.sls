{%- from "kubernetes/map.jinja" import common with context -%}
{%- from "kubernetes/map.jinja" import master with context -%}
{%- if master.enabled %}

addon-dir-create:
  file.directory:
    - name: /etc/kubernetes/addons
    - user: root
    - group: root
    - mode: 0755

{%- if master.network.engine == "opencontrail" and master.network.get('version', 3.0) < 4.0 %}
/etc/kubernetes/addons/contrail-network-controller/contrail-network-controller-configmap.yml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/contrail-network-controller/contrail-network-controller-configmap.yml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

/etc/kubernetes/addons/contrail-network-controller/contrail-network-controller-deploy.yml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/contrail-network-controller/contrail-network-controller-deploy.yml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

{% endif %}

{%- if common.addons.get('virtlet', {}).get('enabled') %}
/etc/kubernetes/addons/virtlet/virtlet-ds.yml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/virtlet/virtlet-ds.yml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

{% endif %}

{%- if common.addons.get('calico_policy', {}).get('enabled', False) and master.network.engine == "calico" %}
/etc/kubernetes/addons/calico_policy/calico-policy-controller.yml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/calico-policy/calico-policy-controller.yml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

{% endif %}


{%- if common.addons.helm.enabled %}
/etc/kubernetes/addons/helm/helm-tiller-deploy.yml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/helm/helm-tiller-deploy.yml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

{% endif %}

{%- if common.addons.storageclass is defined %}

{%- for storageclass_name, storageclass in common.addons.get('storageclass', {}).iteritems() %}

/etc/kubernetes/addons/storageclass/{{ storageclass_name }}.yaml:
  file.managed:
  - source: salt://kubernetes/files/kube-addons/{{ storageclass.provisioner }}.yaml
  - template: jinja
  - makedirs: True
  - dir_mode: 755
  - group: root

{%- endfor %}

{% endif %}

{%- if common.addons.netchecker.enabled %}

{%- for resource in ['svc', 'server', 'agent'] %}

/etc/kubernetes/addons/netchecker/netchecker-{{ resource }}.yml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/netchecker/netchecker-{{ resource }}.yml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

{%- endfor %}

{% endif %}

{%- if common.addons.dns.enabled %}

/etc/kubernetes/addons/dns/kubedns-svc.yaml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/dns/kubedns-svc.yaml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

/etc/kubernetes/addons/dns/kubedns-rc.yaml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/dns/kubedns-rc.yaml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

{% if common.addons.dns.get('autoscaler', {}).get('enabled', True) %}

/etc/kubernetes/addons/dns/kubedns-autoscaler.yaml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/dns/kubedns-autoscaler.yaml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

{% endif %}

{%- if common.addons.coredns.enabled or master.federation.enabled %}

/etc/kubernetes/addons/coredns/coredns-cm.yml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/coredns/coredns-cm.yml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

/etc/kubernetes/addons/coredns/coredns-deploy.yml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/coredns/coredns-deploy.yml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

/etc/kubernetes/addons/coredns/coredns-svc.yml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/coredns/coredns-svc.yml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

/etc/kubernetes/addons/coredns/etcd-svc.yml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/coredns/etcd-svc.yml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

/etc/kubernetes/addons/coredns/etcd-deploy.yml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/coredns/etcd-deploy.yml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True
{% endif %}

{% endif %}

{%- if common.addons.get('externaldns', {}).get('enabled') %}
/etc/kubernetes/addons/externaldns/externaldns-deploy.yaml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/externaldns/externaldns-deploy.yml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True
{% endif %}

{%- if common.addons.dashboard.enabled %}

/etc/kubernetes/addons/dashboard/dashboard-service.yaml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/dashboard/dashboard-service.yaml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

/etc/kubernetes/addons/dashboard/dashboard-controller.yaml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/dashboard/dashboard-controller.yaml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

{% endif %}

{%- if common.addons.heapster_influxdb.enabled %}

/etc/kubernetes/addons/heapster-influxdb/heapster-address.yaml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/heapster-influxdb/heapster-address.yaml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

/etc/kubernetes/addons/heapster-influxdb/heapster-controller.yaml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/heapster-influxdb/heapster-controller.yaml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

/etc/kubernetes/addons/heapster-influxdb/heapster-endpoint.yaml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/heapster-influxdb/heapster-endpoint.yaml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

/etc/kubernetes/addons/heapster-influxdb/heapster-service.yaml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/heapster-influxdb/heapster-service.yaml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

/etc/kubernetes/addons/heapster-influxdb/influxdb-controller.yaml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/heapster-influxdb/influxdb-controller.yaml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

/etc/kubernetes/addons/heapster-influxdb/influxdb-service.yaml:
  file.managed:
    - source: salt://kubernetes/files/kube-addons/heapster-influxdb/influxdb-service.yaml
    - template: jinja
    - group: root
    - dir_mode: 755
    - makedirs: True

{% endif %}

{% endif %}
