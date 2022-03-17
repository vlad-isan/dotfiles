#!/usr/bin/env zsh

#compdef kubectl
# nnao45/zsh-kubectl-completion's version: v0.1.12
#
# Support kubectl version v1.13.5
# Inspired by
#   https://github.com/zsh-users/zsh-completionsrfe/blob/master/src/_golang
#   https://github.com/felixr/docker-zsh-completion/blob/master/_docker
#   https://github.com/git/git/blob/master/contrib/completion/git-completion.zsh

__parse_kube_get(){
  local -a _ns _cl _ur _cx _sv
  if [ ! -z ${_filter_namespace} ];then
    _ns="--namespace ${_filter_namespace}"
  fi
  if [ ! -z ${_filter_cluster} ];then
    _cl="--cluster ${_filter_cluster}"
  fi
  if [ ! -z ${_filter_user} ];then
    _ur="--user ${_filter_user}"
  fi
  if [ ! -z ${_filter_context} ];then
    _cx="--context ${_filter_context}"
  fi
  if [ ! -z ${_filter_server} ];then
    _sv="--server ${_filter_server}"
  fi
  if [ ! -z ${_filter_kubeconfig} ];then
    _kc="--kubeconfig ${_filter_kubeconfig}"
  fi

  if [ ${1} = 'api-resources' ]; then
    eval kubectl ${1} ${_ns} ${_cl} ${_ur} ${_cx} ${_sv} ${_kc} -o wide 2>/dev/null
  elif [ ${1} = 'contexts' ]; then
    eval kubectl config get-contexts ${_ns} ${_cl} ${_ur} ${_cx} ${_sv} ${_kc} 2>/dev/null
  else
    eval kubectl get ${1} ${_ns} ${_cl} ${_ur} ${_cx} ${_sv} ${_kc} -o wide 2>/dev/null
  fi
}

__parse_cmd_result(){
  echo ${1} | tail -n +2 | tr ' ' '$'
}

__parse_cmd_result_withoutcomment(){
  echo ${1} | tail -n +2 | awk '{print $1}'
}

__parse_print2list(){
  echo ${1} | tr '$' ' ' | awk '{print $'${2}'}'
}

__kube_get_exec(){
  local -a _parse_result _parse_list _cmd_result
  integer ret=1
  _cmd_result=$(__parse_kube_get ${1})
  if [ ! -z ${_cmd_result} ]; then
    _parse_result=($(__parse_cmd_result ${_cmd_result}))
    _parse_list=()
    for _r in ${_parse_result}
    do
      _parse_list+=("$(${2} ${_r})")
    done
    _values "${1}" ${_parse_list[@]} && ret=0
  fi
  return ret
}

__kube_get_exec_contexts(){
  local -a _parse_result _parse_list _cmd_result
  integer ret=1
  _cmd_result=$(__parse_kube_get ${1})
  if [ ! -z ${_cmd_result} ]; then
    _parse_result=($(__parse_cmd_result ${_cmd_result}))
    _parse_list=()
    for _r in ${_parse_result}
    do
      _parse_list+=("$(${2} ${_r})")
    done
    compadd ${_parse_list[@]} && ret=0
  fi
  return ret
}


__kube_get_exec_nocomment(){
  local -a _parse_list _cmd_result
  integer ret=1
  _cmd_result=$(__parse_kube_get ${1})
  if [ ! -z ${_cmd_result} ]; then
    _parse_list=($(__parse_cmd_result_withoutcomment ${_cmd_result}))
    _values "${2}" ${_parse_list[@]} && ret=0
  fi
  return ret
}

__output_flag(){
  local -a _default_output_flags _output_withfile_flags
  integer ret=1
  _default_output_flags=(
  'json'
  'yaml'
  'name'
  'custom-columns'
  'custom-columns-file'
  'go-template'
  'go-template-file'
  'jsonpath'
  'jsonpath-file'
  )

  case $words[1] in
    expose | get | edit | delete)
      compadd $_default_output_flags[@] 'wide' && ret=0
    ;;
    api-resources)
      compadd 'wide' 'name' && ret=0
    ;;
    version)
      compadd 'yaml' 'json' && ret=0
    ;;
    *)
      compadd $_default_output_flags[@]  && ret=0
    ;;
  esac

  return ret
}

__kube_get_pods_comment(){
  echo -n $(__parse_print2list ${1} 1)'[ready: '$(__parse_print2list ${1} 2)' status: '$(__parse_print2list ${1} 3)' IP: '$(__parse_print2list ${1} 6)' node: '$(__parse_print2list ${1} 7)']'
}

__kube_get_pods(){
  __kube_get_exec 'pods' __kube_get_pods_comment
}

__kube_get_replicationcontrollers_comment(){
  echo -n $(__parse_print2list ${1} 1)'[image: '$(__parse_print2list ${1} 7)']'
}

__kube_get_api_replicationcontrollers(){
  __kube_get_exec 'replicationcontrollers' __kube_get_replicationcontrollers_comment
}

__kube_get_namespaces_comment(){
  echo -n $(__parse_print2list ${1} 1)'['$(__parse_print2list ${1} 2)']'
}

__kube_get_namespaces(){
  __kube_get_exec 'namespaces' __kube_get_namespaces_comment
}

__kube_get_nodes_comment(){
  echo -n $(__parse_print2list ${1} 1)'[status: '$(__parse_print2list ${1} 2)' role: '$(__parse_print2list ${1} 3)']'
}

__kube_get_nodes(){
  __kube_get_exec 'nodes' __kube_get_nodes_comment
}

__kube_get_services_comment(){
  echo -n $(__parse_print2list ${1} 1)'[type: '$(__parse_print2list ${1} 2)' listen: '$(__parse_print2list ${1} 5)']'
}

__kube_get_services(){
  __kube_get_exec 'services' __kube_get_services_comment
}

__kube_get_componentstatuses_comment(){
  echo -n $(__parse_print2list ${1} 1)'['$(__parse_print2list ${1} 2)']'
}

__kube_get_componentstatuses(){
  __kube_get_exec 'componentstatuses' __kube_get_componentstatuses_comment
}

__kube_get_configmaps_comment(){
  echo -n $(__parse_print2list ${1} 1)
}

__kube_get_configmaps(){
  __kube_get_exec_nocomment 'configmaps' ''
}

__kube_get_podsecuritypolicies(){
  __kube_get_exec_nocomment 'podsecuritypolicies' ''
}

__kube_get_api_resources(){
  local -a comment
  case ${7} in
    explain)
      comment='kubectl explain RESOURCE [options]'
    ;;
    get)
      comment='kubectl get [(-o|--output=)json|yaml|wide|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=...](TYPE[.VERSION][.GROUP] [NAME | -l label] | TYPE[.VERSION][.GROUP]/NAME ...) [flags] [options]'
    ;;
    describe)
      comment='kubectl describe (-f FILENAME | TYPE [NAME_PREFIX | -l label] | TYPE/NAME) [options]'
    ;;
    delete)
      comment='kubectl delete ([-f FILENAME] | TYPE [(NAME | -l label | --all)]) [options]'
    ;;
    patch)
      comment='kubectl patch (-f FILENAME | TYPE NAME) -p PATCH [options]'
    ;;
    label)
      comment='kubectl label [--overwrite] (-f FILENAME | TYPE NAME) KEY_1=VAL_1 ... KEY_N=VAL_N [--resource-version=version] [options]'
    ;;
    annotate)
      comment='kubectl annotate [--overwrite] (-f FILENAME | TYPE NAME) KEY_1=VAL_1 ... KEY_N=VAL_N [--resource-version=version] [options]'
    ;;
    autoscale)
      comment='kubectl autoscale (-f FILENAME | TYPE NAME | TYPE/NAME) [--min=MINPODS] --max=MAXPODS [--cpu-percent=CPU] [options]'
    ;;
    *)
      comment='api resources'
    ;;
  esac
  __kube_get_exec_nocomment 'api-resources' ${comment}
}

__kube_get_api_resources2name(){
  local -a _parse_result __pre_parse_list _parse_list _cmd_result comment
  integer ret=1

  case ${7} in
    wait)
      comment='kubectl wait resource.group/name [--for=delete|--for condition=available] [options]'
    ;;
    port-forward)
      comment='kubectl port-forward TYPE/NAME [options] [LOCAL_PORT:]REMOTE_PORT [...[LOCAL_PORT_N:]REMOTE_PORT_N]'
    ;;
    edit)
      comment='kubectl edit (RESOURCE/NAME | -f FILENAME) [options]'
    ;;
    logs)
      comment='kubectl logs [-f] [-p] (POD | TYPE/NAME) [-c CONTAINER] [options]'
    ;;
    *)
      comment='api resources'
    ;;
  esac

  _cmd_result=$(__parse_kube_get api-resources)
  _pre_parse_list=()
  _parse_list=()
  if [ ! -z ${_cmd_result} ]; then
    _pre_parse_list=($(__parse_cmd_result_withoutcomment ${_cmd_result}))
  fi
  for _a in ${_pre_parse_list}
  do
    case ${_a} in
    bindings)
      #TODO
    ;;
    componentstatuses)
      _parse_list+=('componentstatuses:componentstatuses:__kube_get_componentstatuses')
    ;;
    configmaps)
      _parse_list+=('configmaps:configmaps:__kube_get_configmaps')
    ;;
    endpoints)
      _parse_list+=('endpoints:endpoints:__kube_get_endpoints')
    ;;
    events)
      _parse_list+=('events:events:__kube_get_events')
    ;;
    limitranges)
      _parse_list+=('limitranges:limitranges:__kube_get_limitranges')
    ;;
    namespaces)
      _parse_list+=('namespaces:namespaces:__kube_get_namespaces')
    ;;
    nodes)
      _parse_list+=('nodes:nodes:__kube_get_nodes')
    ;;
    persistentvolumeclaims)
      _parse_list+=('persistentvolumeclaims:persistentvolumeclaims:__kube_get_persistentvolumeclaims')
    ;;
    persistentvolumes)
      _parse_list+=('persistentvolumes:persistentvolumes:__kube_get_persistentvolumes')
    ;;
    pods)
      _parse_list+=('pods:pods:__kube_get_pods')
    ;;
    podtemplates)
      #TODO
    ;;
    replicationcontrollers)
      _parse_list+=('replicationcontrollers:replicationcontrollers:__kube_get_replicationcontrollers')
    ;;
    resourcequotas)
      _parse_list+=('resourcequotas:resourcequotas:__kube_get_resourcequotas')
    ;;
    secrets)
      _parse_list+=('secrets:secrets:__kube_get_secrets')
    ;;
    serviceaccounts)
      _parse_list+=('serviceaccounts:serviceaccounts:__kube_get_serviceaccounts')
    ;;
    services)
      _parse_list+=('services:services:__kube_get_services')
    ;;
    mutatingwebhookconfigurations)
      #TODO
    ;;
    validatingwebhookconfigurations)
      #TODO
    ;;
    customresourcedefinitions)
      _parse_list+=('customresourcedefinitions:customresourcedefinitions:__kube_get_customresourcedefinitions')
    ;;
    apiservices)
      _parse_list+=('apiservices:apiservices:__kube_get_apiservices')
    ;;
    controllerrevisions)
      _parse_list+=('controllerrevisions:controllerrevisions:__kube_get_controllerrevisions')
    ;;
    daemonsets)
      _parse_list+=('daemonsets:daemonsets:__kube_get_daemonsets')
    ;;
    deployments)
      _parse_list+=('deployments:deployments:__kube_get_deployments')
    ;;
    statefulsets)
      _parse_list+=('statefulsets:statefulsets:__kube_get_statefulsets')
    ;;
    ingresses)
      _parse_list+=('ingresses:ingresses:__kube_get_ingresses')
    ;;
    networkpolicies)
      _parse_list+=('networkpolicies:networkpolicies:__kube_get_networkpolicies')
    ;;
    podsecuritypolicies)
      _parse_list+=('podsecuritypolicies:podsecuritypolicies:__kube_get_podsecuritypolicies')
    ;;
    clusterrolebindings)
      _parse_list+=('clusterrolebindings:clusterrolebindings:__kube_get_clusterrolebindings')
    ;;
    clusterroles)
      _parse_list+=('clusterroles:clusterroles:__kube_get_clusterroles')
    ;;
    rolebindings)
      _parse_list+=('rolebindings:rolebindings:__kube_get_rolebindings')
    ;;
    roles)
      _parse_list+=('roles:roles:__kube_get_roles')
    ;;
    storageclasses)
      _parse_list+=('storageclasses:storageclasses:__kube_get_storageclasses')
    ;;
    volumeattachments)
      #TODO
    ;;
  esac
  done

  _values -S '/' ${comment} $_parse_list && ret=0

  return ret
}

__kube_rollout_resources2name(){
  local -a _parse_list
  integer ret=1
  _parse_list=()
  _parse_list+=('daemonsets:daemonsets:__kube_get_daemonsets')
  _parse_list+=('deployments:deployments:__kube_get_deployments')
  _parse_list+=('statefulsets:statefulsets:__kube_get_statefulsets')
  _values -S '/' 'kubectl rollout SUBCOMMAND [options]' $_parse_list && ret=0

  return ret
}

__kube_get_endpoints_comment(){
  echo -n $(__parse_print2list ${1} 1)'[listen: '$(__parse_print2list ${1} 2)']'
}

__kube_get_endpoints(){
  __kube_get_exec 'endpoints' __kube_get_endpoints_comment
}

__kube_get_events_comment(){
  echo -n $(__parse_print2list ${1} 4)'[reasen: '$(__parse_print2list ${1} 7)']'
}

__kube_get_events(){
  __kube_get_exec 'events' __kube_get_events_comment
}

__kube_get_limitranges_comment(){
  echo -n $(__parse_print2list ${1} 1)'[created_at: '$(__parse_print2list ${1} 2)']'
}

__kube_get_limitranges(){
  __kube_get_exec 'limitranges' __kube_get_limitranges_comment
}

__kube_get_resourcequotas_comment(){
  echo -n $(__parse_print2list ${1} 1)'[created_at: '$(__parse_print2list ${1} 2)']'
}

__kube_get_resourcequotas(){
  __kube_get_exec 'resourcequotas' __kube_get_resourcequotas_comment
}

__kube_get_customresourcedefinitions_comment(){
  echo -n $(__parse_print2list ${1} 1)'[created_at: '$(__parse_print2list ${1} 2)']'
}

__kube_get_customresourcedefinitions(){
  __kube_get_exec 'customresourcedefinitions' __kube_get_customresourcedefinitions_comment
}

__kube_get_persistentvolumeclaims_comment(){
  echo -n $(__parse_print2list ${1} 1)'[volume: '$(__parse_print2list ${1} 4)' storageclass: '$(__parse_print2list ${1} 6)']'
}

__kube_get_persistentvolumeclaims(){
  __kube_get_exec 'persistentvolumeclaims' __kube_get_persistentvolumeclaims_comment
}

__kube_get_persistentvolumes_comment(){
  _pv_claim=$(echo ${1} | tr '$' ' ' | awk '{print $6}')
  echo -n $(__parse_print2list ${1} 1)'[claim: '$(echo ${_pv_claim} | awk -F '/' '{print $2}')' storageclass: '$(__parse_print2list ${1} 7)']'
}

__kube_get_persistentvolumes(){
  __kube_get_exec 'persistentvolumes' __kube_get_persistentvolumes_comment
}

__kube_get_secrets_comment(){
  echo -n $(__parse_print2list ${1} 1)'['$(__parse_print2list ${1} 2)']'
}

__kube_get_secrets(){
  __kube_get_exec 'secrets' __kube_get_secrets_comment
}

__kube_get_serviceaccounts(){
  __kube_get_exec_nocomment 'serviceaccounts' ${7}
}

__kube_get_apiservices_comment(){
  echo -n $(__parse_print2list ${1} 1)'[created_at: '$(__parse_print2list ${1} 2)']'
}

__kube_get_apiservices(){
  __kube_get_exec_nocomment 'apiservices' ${7}
}

__kube_get_controllerrevisions_comment(){
  echo -n $(__parse_print2list ${1} 1)'['$(__parse_print2list ${1} 2)']'
}

__kube_get_controllerrevisions(){
  __kube_get_exec 'controllerrevisions' __kube_get_controllerrevisions_comment
}

__kube_get_daemonsets_comment(){
  echo -n $(__parse_print2list ${1} 1)'[desired: '$(__parse_print2list ${1} 2)' current: '$(__parse_print2list ${1} 3)' ready: '$(__parse_print2list ${1} 4)' up-to-date: '$(__parse_print2list ${1} 5)' available: '$(__parse_print2list ${1} 6)']'
}

__kube_get_daemonsets(){
  __kube_get_exec 'daemonsets' __kube_get_daemonsets_comment
}

__kube_get_deployments_comment(){
  echo -n $(__parse_print2list ${1} 1)'[desired: '$(__parse_print2list ${1} 2)' current: '$(__parse_print2list ${1} 3)' up-to-date: '$(__parse_print2list ${1} 4)' available: '$(__parse_print2list ${1} 5)']'
}

__kube_get_deployments(){
  __kube_get_exec 'deployments' __kube_get_deployments_comment
}

__kube_get_statefulsets_comment(){
  echo -n $(__parse_print2list ${1} 1)'[desired: '$(__parse_print2list ${1} 2)' current: '$(__parse_print2list ${1} 3)' up-to-date: '$(__parse_print2list ${1} 4)']'
}

__kube_get_statefulsets(){
  __kube_get_exec 'statefulsets' __kube_get_statefulsets_comment
}

__kube_get_ingresses_comment(){
  echo -n $(__parse_print2list ${1} 1)'[hosts: '$(__parse_print2list ${1} 2)' lieten '$(__parse_print2list ${1} 3)':'$(__parse_print2list ${1} 4)']'
}

__kube_get_ingresses(){
  __kube_get_exec 'ingresses' __kube_get_ingresses_comment
}

__kube_get_networkpolicies_comment(){
  echo -n $(__parse_print2list ${1} 1)'[pod-selector: '$(__parse_print2list ${1} 2)']'
}

__kube_get_networkpolicies(){
  __kube_get_exec 'networkpolicies' __kube_get_networkpolicies_comment
}

__kube_get_clusterrolebindings(){
  __kube_get_exec_nocomment 'clusterrolebindings' ''
}

__kube_get_clusterroles(){
  __kube_get_exec_nocomment 'clusterroles' ''
}

__kube_get_rolebindings(){
  __kube_get_exec_nocomment 'rolebindings' ''
}

__kube_get_roles(){
  __kube_get_exec_nocomment 'roles' ''
}

__kube_get_storageclasses_comment(){
  echo -n $(__parse_print2list ${1} 1)'[provisioner: '$(__parse_print2list ${1} 2)']'
}

__kube_get_storageclasses(){
  __kube_get_exec 'storageclasses' __kube_get_storageclasses_comment
}

__kube_get_contexts_comment(){
  if echo ${1} | grep '*' > /dev/null 2>&1; then
    echo -n $(__parse_print2list ${1} 2)
  else
    echo -n $(__parse_print2list ${1} 1)
  fi
}

__kube_get_contexts(){
  __kube_get_exec_contexts 'contexts' __kube_get_contexts_comment
}

__hook_api_resources(){
  case $words[2] in
    bindings)
      #TODO
    ;;
    componentstatuses)
      __kube_get_componentstatuses
    ;;
    configmaps)
      __kube_get_configmaps
    ;;
    endpoints)
      __kube_get_endpoints
    ;;
    events)
      __kube_get_events
    ;;
    limitranges)
      __kube_get_limitranges
    ;;
    namespaces)
      __kube_get_namespaces
    ;;
    nodes)
      __kube_get_nodes
    ;;
    persistentvolumeclaims)
      __kube_get_persistentvolumeclaims
    ;;
    persistentvolumes)
      __kube_get_persistentvolumes
    ;;
    pods)
      __kube_get_pods
    ;;
    podtemplates)
      #TODO
    ;;
    replicationcontrollers)
      __kube_get_api_replicationcontrollers
    ;;
    resourcequotas)
      __kube_get_resourcequotas
    ;;
    secrets)
      __kube_get_secrets
    ;;
    serviceaccounts)
      __kube_get_serviceaccounts
    ;;
    services)
      __kube_get_services
    ;;
    mutatingwebhookconfigurations)
      #TODO
    ;;
    validatingwebhookconfigurations)
      #TODO
    ;;
    customresourcedefinitions)
      __kube_get_customresourcedefinitions
    ;;
    apiservices)
      __kube_get_apiservices
    ;;
    controllerrevisions)
      __kube_get_controllerrevisions
    ;;
    daemonsets)
      __kube_get_daemonsets
    ;;
    deployments)
      __kube_get_deployments
    ;;
    statefulsets)
      __kube_get_statefulsets
    ;;
    ingresses)
      __kube_get_ingresses
    ;;
    networkpolicies)
      __kube_get_networkpolicies
    ;;
    podsecuritypolicies)
      __kube_get_podsecuritypolicies
    ;;
    clusterrolebindings)
      __kube_get_clusterrolebindings
    ;;
    clusterroles)
      __kube_get_clusterroles
    ;;
    rolebindings)
      __kube_get_rolebindings
    ;;
    roles)
      __kube_get_roles
    ;;
    storageclasses)
      __kube_get_storageclasses
    ;;
    volumeattachments)
      #TODO
    ;;
  esac
}


__create_cmd(){
  local -a _create_cmds
  integer ret=1
  _create_cmds=(
  'clusterrole[Create a ClusterRole.]'
  'clusterrolebinding[Create a ClusterRoleBinding for a particular ClusterRole]'
  'configmap[Create a configmap from a local file, directory or literal value]'
  'deployment[Create a deployment with the specified name.]'
  'job[Create a job with the specified name.]'
  'help[Get more information about a this command help]'
  'namespace[Create a namespace with the specified name.]'
  'poddisruptionbudget[Create a pod disruption budget with the specified name.]'
  'priorityclass[Create a priorityclass with the specified name.]'
  'quota[Create a quota with the specified name.]'
  'role[Create a role with single rule.]'
  'rolebinding[Create a RoleBinding for a particular Role or ClusterRole]'
  'secret[Create a secret using specified subcommand]'
  'service[Create a service using specified subcommand.]'
  'serviceaccount[Create a service account with the specified name.]'
  )
  _values 'kubectl create -f FILENAME [options]' $_create_cmds[@] && ret=0

  return ret
}

__expose_cmd(){
  local -a _expose_cmds
  integer ret=1
  _expose_cmds=(
  'pod:pod:__kube_get_pods'
  'service:service:__kube_get_services'
  'replicationcontroller'
  'deployment:deployment:__kube_get_deployments'
  'replicaset'
  )
  _values 'kubectl expose (-f FILENAME | TYPE NAME) [--port=port] [--protocol=TCP|UDP|SCTP] [--target-port=number-or-name] [--name=name] [--external-ip=external-ip-of-service] [--type=type] [options]' $_expose_cmds[@] && ret=0

  return ret
}

__set_cmd(){
  local -a _set_cmds
  integer ret=1
  _set_cmds=(
  'env[Update environment variables on a pod template]'
  'image[Update image of a pod template]'
  'resources[Update resource requests/limits on objects with pod templates]'
  'selector[Set the selector on a resource]'
  'serviceaccount[Update ServiceAccount of a resource]'
  'subject[Update User, Group or ServiceAccount in a RoleBinding/ClusterRoleBinding]'
  )
  _values 'kubectl set SUBCOMMAND [options]' $_set_cmds[@] && ret=0

  return ret
}

__rollout_cmd(){
  local -a _rollout_cmds
  integer ret=1
  _rollout_cmds=(
  'history[View rollout history]'
  'pause[Mark the provided resource as paused]'
  'resume[Resume a paused resource]'
  'status[Show the status of the rollout]'
  'undo[Undo a previous rollout]'
  )
  _values 'kubectl rollout SUBCOMMAND [options]' $_rollout_cmds[@] && ret=0

  return ret
}

__scale_cmd() {
  local -a _scale_cmds
  integer ret=1
  _scale_cmds=(
  '--replicas[The new desired number of replicas. Required.]'
  )
  _values 'kubectl scale [--resource-version=version] [--current-replicas=count] --replicas=COUNT (-f FILENAME | TYPE NAME) [options]' $_scale_cmds[@] && ret=0

  return ret
}

__hook_autoscale_cmd() {
  local -a _hook_autoscale_cmds
  integer ret=1
  _hook_autoscale_cmds=(
  '--max[The upper limit for the number of pods that can be set by the autoscaler. Required.]'
  )
  _values 'kubectl autoscale (-f FILENAME | TYPE NAME | TYPE/NAME) [--min=MINPODS] --max=MAXPODS [--cpu-percent=CPU] [options]' $_hook_autoscale_cmds[@] && ret=0

  return ret
}

__certificate_cmd(){
  local -a _certificate_cmds
  integer ret=1
  _certificate_cmds=(
  'approve[Approve a certificate signing request]'
  'deny[Deny a certificate signing request]'
  )
  _values 'certificate command' $_certificate_cmds[@] && ret=0

  return ret
}

__clusterinfo_cmd(){
  local -a _clusterinfo_cmds
  integer ret=1
  _clusterinfo_cmds=(
  'dump[Dump lots of relevant info for debugging and diagnosis]'
  )
  _values 'clusterinfo command' $_clusterinfo_cmds[@] && ret=0

  return ret
}

__top_cmd(){
  local -a _top_cmds
  integer ret=1
  _top_cmds=(
  'node[Display Resource (CPU/Memory/Storage) usage of nodes]'
  'pod[Display Resource (CPU/Memory/Storage) usage of pods]'
  )
  _values 'kubectl top [flags] [options]' $_top_cmds[@] && ret=0

  return ret
}

__auth_cmd(){
  local -a _auth_cmds
  integer ret=1
  _auth_cmds=(
  'can-i[Check whether an action is allowed]'
  'reconcile[Reconciles rules for RBAC Role, RoleBinding, ClusterRole, and ClusterRole binding objects]'
  )
  _values 'kubectl auth [flags] [options]' $_auth_cmds[@] && ret=0

  return ret
}

__completion_cmd(){
  local -a _completion_cmds
  integer ret=1
  _completion_cmds=(
  'zsh[Shell designed for interactive use, although it is also a powerful scripting language.]'
  'bash[Unix shell and command language written by Brian Fox for the GNU Project as a free software replacement for the Bourne shell.]'
  )
  _values 'completion command' $_completion_cmds[@] && ret=0

  return ret
}

# No alpha commands are available in this version of kubectl
# __alpha_cmd(){
#   local -a _alpha_cmds
#   integer ret=1
#   _alpha_cmds=(
#   )
#   _values 'alpha command' $_alpha_cmds[@] && ret=0
#
#   return ret
# }

__config_cmd(){
  local -a _config_cmds
  integer ret=1
  _config_cmds=(
  'current-context[Displays the current-context]'
  'delete-cluster[Delete the specified cluster from the kubeconfig]'
  'delete-context[Delete the specified context from the kubeconfig]'
  'get-clusters[Display clusters defined in the kubeconfig]'
  'get-contexts[Describe one or many contexts]'
  'rename-context[Renames a context from the kubeconfig file.]'
  'set[Sets an individual value in a kubeconfig file]'
  'set-cluster[Sets a cluster entry in kubeconfig]'
  'set-context[Sets a context entry in kubeconfig]'
  'set-credentials[Sets a user entry in kubeconfig]'
  'unset[Unsets an individual value in a kubeconfig file]'
  'use-context[Sets the current-context in a kubeconfig file]'
  'view[Display merged kubeconfig settings or a specified kubeconfig file]'
  )
  _values 'kubectl config SUBCOMMAND [options]' $_config_cmds[@] && ret=0

  return ret
}

__plugin_cmd(){
  local -a _plugin_cmds
  integer ret=1
  _plugin_cmds=(
  'list[list all visible plugin executables on a user'\''s PATH]'
  )
  _values 'kubectl plugin [flags] [options]' $_plugin_cmds[@] && ret=0

  return ret
}

__basic_cmd(){
  local -a _basic_cmds
  integer ret=1
  _basic_cmds=(
  'create[Create a resource from a file or from stdin.]'
  'expose[Take a replication controller, service, deployment or pod and expose it as a new Kubernetes Service]'
  'run[Run a particular image on the cluster]'
  'set[Set specific features on objects]'
  'explain[Documentation of resources]'
  'get[Display one or many resources]'
  'edit[Edit a resource on the server]'
  'delete[Delete resources by filenames, stdin, resources and names, or by resources and label selector]'
  'rollout[Manage the rollout of a resource]'
  'scale[Set a new size for a Deployment, ReplicaSet, Replication Controller, or Job]'
  'autoscale[Auto-scale a Deployment, ReplicaSet, or ReplicationController]'
  'certificate[Modify certificate resources.]'
  'cluster-info[Display cluster info]'
  'top[Display Resource (CPU/Memory/Storage) usage.]'
  'cordon[Mark node as unschedulable]'
  'uncordon[Mark node as schedulable]'
  'drain[Drain node in preparation for maintenance]'
  'taint[Update the taints on one or more nodes]'
  'describe[Show details of a specific resource or group of resources]'
  'logs[Print the logs for a container in a pod]'
  'attach[Attach to a running container]'
  'exec[Execute a command in a container]'
  'port-forward[Forward one or more local ports to a pod]'
  'proxy[Run a proxy to the Kubernetes API server]'
  'cp[Copy files and directories to and from containers.]'
  'auth[Inspect authorization]'
  'diff[Diff live version against would-be applied version]'
  'apply[Apply a configuration to a resource by filename or stdin]'
  'patch[Update field(s) of a resource using strategic merge patch]'
  'replace[Replace a resource by filename or stdin]'
  'wait[Experimental: Wait for a specific condition on one or many resources.]'
  'convert[Convert config files between different API versions]'
  'label[Update the labels on a resource]'
  'annotate[Update the annotations on a resource]'
  'completion[Output shell completion code for the specified shell (bash or zsh)]'
  # No alpha commands are available in this version of kubectl
  # 'alpha[Commands for features in alpha]'
  'api-resources[Print the supported API resources on the server]'
  'api-versions[Print the supported API versions on the server, in the form of \"group/version\"]'
  'config[Modify kubeconfig files]'
  'plugin[Provides utilities for interacting with plugins.]'
  'version[Print the client and server version information]'
  'help[Help about any command]'
  'options[List of global command-line options (applies to all commands).]'
  )
  _values 'kubectl [flags] [options]' $_basic_cmds[@] && ret=0

  return ret
}

_kubectl(){
  typeset -A opt_args
  integer ret=1

  local -a _global_flags
  _global_flags=(
  '--alsologtostderr[log to standard error as well as files]'
  '--as[Username to impersonate for the operation]'
  '--as-group[Group to impersonate for the operation, this flag can be repeated to specify multiple groups.]'
  '--cache-dir[Default HTTP cache directory]'
  '--certificate-authority[Path to a cert file for the certificate authority]'
  '--client-certificate[Path to a client certificate file for TLS]'
  '--client-key[Path to a client key file for TLS]'
  '--cluster[The name of the kubeconfig cluster to use]'
  '--context[The name of the kubeconfig context to use]:contexts:__kube_get_contexts'
  '--help[Get more information about a this command help]'
  '--insecure-skip-tls-verify[If true, the server'\''s certificate will not be checked for validity. This will make your HTTPS connections insecure]'
  '--kubeconfig[Path to the kubeconfig file to use for CLI requests.]:kubeconfig:_files'
  '--log-backtrace-at[when logging hits line file[N, emit a stack trace]'
  '--log-dir[If non-empty, write log files in this directory]:dirs:_files'
  '--log-flush-frequency[Maximum number of seconds between log flushes]'
  '--logtostderr=true[log to standard error instead of files]'
  '--match-server-version[Require server version to match client version]'
  {-n,--namespace}'[If present, the namespace scope for this CLI request]:namespaces:__kube_get_namespaces'
  '--password[Password for basic authentication to the API server]'
  '--profile[Name of profile to capture. One of (none|cpu|heap|goroutine|threadcreate|block|mutex)]'
  '--profile-output[Name of the file to write the profile to]'
  '--request-timeout[The length of time to wait before giving up on a single server request. Non-zero values should contain a corresponding time unit (e.g. 1s, 2m, 3h). A value of zero means don'\''t timeout requests.]'
  {-s,--server}'[The address and port of the Kubernetes API server]'
  '--stderrthreshold[logs at or above this threshold go to stderr]'
  '--token[Bearer token for authentication to the API server]'
  '--user[The name of the kubeconfig user to use]'
  '--username[Username for basic authentication to the API server]'
  {-v,--v}'[level for V logs]'
  '--vmodule[comma-separated list of pattern=N settings for file-filtered logging]'
  )

  _arguments  \
    ${_global_flags[@]} \
    "1: :{_alternative ':basic_cmd:__basic_cmd'}" \
    '*:: :->args' && ret=0

  case $state in
    args)

      if [ ! -z ${opt_args[-n]} ]; then
        _filter_namespace=${opt_args[-n]}
      fi

      if [ ! -z ${opt_args[--namespace]} ]; then
        _filter_namespace=${opt_args[--namespace]}
      fi

      if [ ! -z ${opt_args[--cluster]} ]; then
        _filter_cluster=${opt_args[--cluster]}
      fi

      if [ ! -z ${opt_args[--user]} ]; then
        _filter_user=${opt_args[--user]}
      fi

      if [ ! -z ${opt_args[--context]} ]; then
        _filter_context=${opt_args[--context]}
      fi

      if [ ! -z ${opt_args[--server]} ]; then
        _filter_server=${opt_args[--server]}
      fi

      if [ ! -z ${opt_args[--kubeconfig]} ]; then
        _filter_kubeconfig=${opt_args[--kubeconfig]}
      fi


      case $words[1] in
        create)
          _arguments \
            ${_global_flags[@]} \
            '--allow-missing-template-keys[If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to golang and jsonpath output formats.]' \
            '--dry-run[If true, only print the object that would be sent, without sending it.]' \
            '--edit[Edit the API resource before creating]' \
            '(-f --filename)'{-f,--filename}'[Filename, directory, or URL to files to use to create the resource]:files:_files' \
            '--help[Get more information about a this command help]' \
            '(-o --output)'{-o,--output}'[Output format. One of:json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=...See custom columns \[http://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns\], golang template \[http://golang.org/pkg/text/template/#pkg-overview\] and jsonpath template \[http://kubernetes.io/docs/user-guide/jsonpath\].]:output_flag:__output_flag' \
            '--raw[Raw URI to POST to the server.  Uses the transport specified by the kubeconfig file.]' \
            '--record[Record current kubectl command in the resource annotation. If set to false, do not record the command. If set to true, record the command. If not set, default to updating the existing annotation value only if one already exists.]' \
            '(-R --recursive)'{-R,--recursive}'[Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests organized within the same directory.]' \
            '--save-config[If true, the configuration of current object will be saved in its annotation. Otherwise, the annotation will be unchanged. This flag is useful when you want to perform kubectl apply on this object in the future.]' \
            '(-l --selector)'{-l,--selector}'[Selector (label query) to filter on, supports '=', '==', and '!='.(e.g. -l key1=value1,key2=value2)]' \
            '--template[Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format is golang templates \[http://golang.org/pkg/text/template/#pkg-overview\].]' \
            '--validate[If true, use a schema to validate the input before sending it]' \
            '--windows-line-endings[Only relevant if --edit=true. Defaults to the line ending native to your platform.]' \
            "1: :{_alternative ':create_cmd:__create_cmd' }"  && ret=0
        ;;

        expose)
          _arguments \
            ${_global_flags[@]} \
            '--allow-missing-template-keys[If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to golang and jsonpath output formats.]' \
            '--cluster-ip[ClusterIP to be assigned to the service. Leave empty to auto-allocate, or set to '\''None'\'' to create a headless service.]' \
            '--dry-run[If true, only print the object that would be sent, without sending it.]' \
            '--external-ip[Additional external IP address (not managed by Kubernetes) to accept for the service. If this IP is routed to a node, the service can be accessed by this IP in addition to its generated service IP.]' \
            '(-f --filename)'{-f,--filename}'[Filename, directory, or URL to files identifying the resource to expose a service]:files:_files' \
            '--generator[The name of the API generator to use. There are 2 generators: '\''service/v1'\'' and '\''service/v2'\''. The only difference between them is that service port in v1 is named '\''default'\'', while it is left unnamed in v2. Default is '\''service/v2'\''.]' \
            '--help[Get more information about a this command help]' \
            '(-l --labels)'{-l,--labels}'[Labels to apply to the service created by this call.]' \
            '--load-balancer-ip[IP to assign to the LoadBalancer. If empty, an ephemeral IP will be created and used \(cloud-provider specific\).]' \
            '--name[The name for the newly created object.]' \
            '(-o --output)'{-o,--output}'[Output format. One of:json|yaml|name|go-template|go-template-file|template|templatefile|jsonpath|jsonpath-file.]:output_flag:__output_flag' \
            '--overrides[An inline JSON override for the generated object. If this is non-empty, it is used to override the generated object. Requires that the object supply a valid apiVersion field. ]' \
            '--port[The port that the service should serve on. Copied from the resource being exposed, if unspecified]' \
            '--protocol[The network protocol for the service to be created. Default is '\''TCP'\''.]' \
            '--record[Record current kubectl command in the resource annotation. If set to false, do not record the command. If set to true, record the command. If not set, default to updating the existing annotation value only if one already exists.]' \
            '(-R --recursive)'{-R,--recursive}'[Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests organized within the same directory.]' \
            '--save-config[If true, the configuration of current object will be saved in its annotation. Otherwise, the annotation will be unchanged. This flag is useful when you want to perform kubectl apply on this object in the future.]' \
            '--selector[Selector (label query) to filter on, supports '\''='\'', '\''=='\'', and '\''!='\''.(e.g. -l key1=value1,key2=value2)]' \
            '--session-affinity[If non-empty, set the session affinity for the service to this; legal values: '\''None'\'', '\''ClientIP'\'']' \
            '--target-port[Name or number for the port on the container that the service should direct traffic to. Optional.]' \
            '--template[Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format is golang templates \[http://golang.org/pkg/text/template/#pkg-overview\].]' \
            '--type[Type for this service: ClusterIP, NodePort, LoadBalancer, or ExternalName. Default is '\''ClusterIP'\''.]' \
            "1: :{_alternative ':expose_cmd:__expose_cmd' }"  && ret=0
        ;;

        run)
          _arguments \
            ${_global_flags[@]} \
            '--allow-missing-template-keys[If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to golang and jsonpath output formats.]' \
            '--attach=[If true, wait for the Pod to start running, and then attach to the Pod as if '\''kubectl attach ...'\'' were called.  Default false, unless '\''-i/--stdin'\'' is set, in which case the default is true. With '\''--restart=Never'\'' the exit code of the container process is returned.]' \
            '--cascade[If true, cascade the deletion of the resources managed by this resource (e.g. Pods created by a ReplicationController).  Default true.]' \
            '--command[If true and extra arguments are present, use them as the 'command' field in the container, rather than the 'args' field which is the default.]' \
            '--dry-run[If true, only print the object that would be sent, without sending it.]' \
            '--env[Environment variables to set in the container]' \
            '--expose[If true, a public, external service is created for the container(s) which are run]' \
            '(-f --filename)'{-f,--filename}'[Filename, directory, or URL to files to use to create the resource]:files:_files' \
            '--force[Only used when grace-period=0. If true, immediately remove resources from API and bypass graceful deletion. Note that immediate deletion of some resources may result in inconsistency or data loss and requires confirmation.]' \
            '--generator[The name of the API generator to use. There are 2 generators: '\''service/v1'\'' and '\''service/v2'\''. The only difference between them is that service port in v1 is named '\''default'\'', while it is left unnamed in v2. Default is '\''service/v2'\''.]' \
            '--help[Get more information about a this command help]' \
            '--grace-period[Period of time in seconds given to the resource to terminate gracefully. Ignored if negative. Set to 1 for immediate shutdown. Can only be set to 0 when --force is true (force deletion).]' \
            '--hostport[The host port mapping for the container port. To demonstrate a single-machine container.]' \
            '--image[The image for the container to run.]' \
            '--image-pull-policy[The image pull policy for the container. If left empty, this value will not be specified by the client and defaulted by the server]' \
            '(-l --labels)'{-l,--labels}'[Labels to apply to the service created by this call.]' \
            '--leave-stdin-open[ If the pod is started in interactive mode or with stdin, leave stdin open after the first attach completes. By default, stdin will be closed after the first attach completes.]' \
            '--limits[The resource requirement limits for this container.  For example, '\''cpu=200m,memory=512Mi'\''.  Note that server side components may assign limits depending on the server configuration, such as limit ranges.]' \
            '(-o --output)'{-o,--output}'[Output format. One of:json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=...See custom columns \[http://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns\], golang template \[http://golang.org/pkg/text/template/#pkg-overview\] and jsonpath template \[http://kubernetes.io/docs/user-guide/jsonpath\].]:output_flag:__output_flag' \
            '--overrides[An inline JSON override for the generated object. If this is non-empty, it is used to override the generated object. Requires that the object supply a valid apiVersion field. ]' \
            '--pod-running-timeout[The length of time (like 5s, 2m, or 3h, higher than zero) to wait until at least one pod is running]' \
            '--port[The port that this container exposes.  If --expose is true, this is also the port used by the service that is created.]' \
            '--quiet[If true, suppress prompt messages.]' \
            '--record[Record current kubectl command in the resource annotation. If set to false, do not record the command. If set to true, record the command. If not set, default to updating the existing annotation value only if one already exists.]' \
            '(-R --recursive)'{-R,--recursive}'[Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests organized within the same directory.]' \
            '(-r --replicas)'{-r,--replicas}'[Number of replicas to create for this container. Default is 1.]' \
            '--requests[The resource requirement requests for this container.  For example, '\''cpu=100m,memory=256Mi'\''.  Note that server side components may assign requests depending on the server configuration, such as limit ranges.]' \
            '--restart[The restart policy for this Pod.  Legal values \[Always, OnFailure, Never\].  If set to '\''Always'\'' a deployment is created, if set to '\''OnFailure'\'' a job is created, if set to '\''Never'\'', a regular pod is created. For the latter two --replicas must be 1.  Default '\''Always'\'', for CronJobs '\''Never'\''.]' \
            '--rm[If true, delete resources created in this command for attached containers.]' \
            '--save-config[If true, the configuration of current object will be saved in its annotation. Otherwise, the annotation will be unchanged. This flag is useful when you want to perform kubectl apply on this object in the future.]' \
            '--schedule[A schedule in the Cron format the job should be run with.]' \
            '--service-generator[The name of the generator to use for creating a service.  Only used if --expose is true]' \
            '--service-overrides[An inline JSON override for the generated service object. If this is non-empty, it is used to override the generated object. Requires that the object supply a valid apiVersion field.  Only used if --expose is true.]' \
            '--serviceaccount[Service account to set in the pod spec]' \
            '(-i --stdin)'{-i,--stdin}'[Keep stdin open on the container(s) in the pod, even if nothing is attached.]' \
            '--template[Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format is golang templates \[http://golang.org/pkg/text/template/#pkg-overview\].]' \
            '--timeout[The length of time to wait before giving up on a delete, zero means determine a timeout from the size of the object]' \
            '(-t --tty)'{-t,--tty}'[Allocated a TTY for each container in the pod.]' \
            '--wait[If true, wait for resources to be gone before returning. This waits for finalizers.]' \ && ret=0
        ;;

        set)
          _arguments \
            ${_global_flags[@]} \
            "1: :{_alternative ':set_cmd:__set_cmd' }" && ret=0
        ;;

        explain)
          _arguments \
            ${_global_flags[@]} \
            "1: :{_alternative ':get_resources:__kube_get_api_resources explain' }" && ret=0
        ;;

        get)
          _arguments \
            ${_global_flags[@]} \
            '--all-namespaces[If present, list the requested object(s) across all namespaces. Namespace in current context is ignored even if specified with --namespace.]' \
            '--allow-missing-template-key[If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to golang and jsonpath output formats.]' \
            '--chunk-size[Return large lists in chunks rather than all at once. Pass 0 to disable. This flag is beta and may change in the future.]' \
            '--export[If true, use '\''export'\'' for the resources.  Exported resources are stripped of cluster-specific information.]' \
            '--field-selector[Selector (field query) to filter on, supports '\''='\'', '\''=='\'', and '\''!='\''.(e.g. --field-selector key1=value1,key2=value2). The server only supports a limited number of field queries per type.]' \
            '(-f --filename)'{-f,--filename}'[Filename, directory, or URL to files to use to create the resource]' \
            '--ignore-not-found[If the requested object does not exist the command will return exit code 0.]' \
            '--include-uninitialized[If true, the kubectl command applies to uninitialized objects. If explicitly set to false, this flag overrides other flags that make the kubectl commands apply to uninitialized objects, e.g., \"--all\". Objects with empty metadata.initializers are regarded as initialized.]' \
            '(-L --label-columns)'{-L,--label-columns}'[Accepts a comma separated list of labels that are going to be presented as columns. Names are case-sensitive. You can also use multiple flag options like -L label1 -L label2...]' \
            '--no-headers[When using the default or custom-column output format, don'\''t print headers (default print headers).]' \
            '(-o --output)'{-o,--output}'[Output format. One of:json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=...See custom columns \[http://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns\], golang template \[http://golang.org/pkg/text/template/#pkg-overview\] and jsonpath template \[http://kubernetes.io/docs/user-guide/jsonpath\].]:output_flag:__output_flag' \
            '--raw[Raw URI to request from the server.  Uses the transport specified by the kubeconfig file.]' \
            '(-R --recursive)'{-R,--recursive}'[Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests organized within the same directory.]' \
            '(-l --selector)'{-l,--selector}'[Selector (label query) to filter on, supports '\''='\'', '\''=='\'', and '\''!='\''.(e.g. -l key1=value1,key2=value2)]' \
            '--server-print[If true, have the server return the appropriate table output. Supports extension APIs and CRDs.]' \
            '--show-kind[If present, list the resource type for the requested object(s).]' \
            '--show-labels[When printing, show all labels as the last column (default hide labels column)]' \
            '--sort-by[If non-empty, sort list types using this field specification.  The field specification is expressed as a JSONPath expression \(e.g. '\''\{.metadata.name\}'\''\). The field in the API resource specified by this JSONPath expression must be an integer or a string.]' \
            '--template[Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format is golang templates \[http://golang.org/pkg/text/template/#pkg-overview\].]' \
            '--use-openapi-print-columns[If true, use x-kubernetes-print-column metadata (if present) from the OpenAPI schema for displaying a resource.]' \
            '(-w --watch)'{-w,--watch}'[After listing/getting the requested object, watch for changes. Uninitialized objects are excluded if no object name is provided.]' \
            '--watch-only[Watch for changes to the requested object(s), without listing/getting first.]' \
            "1: :{_alternative ':get_resources:__kube_get_api_resources get' }" \
            "2: :{_alternative ':get_resources:__hook_api_resources'}" && ret=0
        ;;

        edit)
          _arguments \
            ${_global_flags[@]} \
            '--allow-missing-template-keys[If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to golang and jsonpath output formats.]' \
            '(-f --filename)'{-f,--filename}'[Filename, directory, or URL to files to use to create the resource]:files:_files' \
            '--include-uninitialized[If true, the kubectl command applies to uninitialized objects. If explicitly set to false, this flag overrides other flags that make the kubectl commands apply to uninitialized objects, e.g., "--all". Objects with empty metadata.initializers are regarded as initialized.]' \
            '(-o --output)'{-o,--output}'[Output format. One of:json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=...See custom columns \[http://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns\], golang template \[http://golang.org/pkg/text/template/#pkg-overview\] and jsonpath template \[http://kubernetes.io/docs/user-guide/jsonpath\].]:output_flag:__output_flag' \
            '--output-patch[Output the patch if the resource is edited.]' \
            '--record[Record current kubectl command in the resource annotation. If set to false, do not record the command. If set to true, record the command. If not set, default to updating the existing annotation value only if one already exists.]' \
            '(-R --recursive)'{-R,--recursive}'[Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests organized within the same directory.]' \
            '--save-config[If true, the configuration of current object will be saved in its annotation. Otherwise, the annotation will be unchanged. This flag is useful when you want to perform kubectl apply on this object in the future.]' \
            '--template[Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format is golang templates \[http://golang.org/pkg/text/template/#pkg-overview\].]' \
            '--validate[If true, use a schema to validate the input before sending it]' \
            '--windows-line-endings[Defaults to the line ending native to your platform.]' \
            "1: :{_alternative ':get_resources:__kube_get_api_resources2name edit' }" && ret=0
        ;;

        delete)
          _arguments \
            ${_global_flags[@]} \
            '--all[Delete all resources, including uninitialized ones, in the namespace of the specified resource types.]' \
            '--cascade[If true, cascade the deletion of the resources managed by this resource (e.g. Pods created by a ReplicationController).  Default true.]' \
            '--field-selector[Selector (field query) to filter on, supports '\''='\'', '\''=='\'', and '\''!='\''.(e.g. --field-selector key1=value1,key2=value2). The server only supports a limited number of field queries per type.]' \
            '(-f --filename)'{-f,--filename}'[Filename, directory, or URL to files to use to create the resource]:files:_files' \
            '--force[Only used when grace-period=0. If true, immediately remove resources from API and bypass graceful deletion. Note that immediate deletion of some resources may result in inconsistency or data loss and requires confirmation.]' \
            '--grace-period[Period of time in seconds given to the resource to terminate gracefully. Ignored if negative. Set to 1 for immediate shutdown. Can only be set to 0 when --force is true (force deletion).]' \
            '--ignore-not-found[Treat \"resource not found\" as a successful delete. Defaults to \"true\" when --all is specified.]' \
            '--include-uninitialized[If true, the kubectl command applies to uninitialized objects. If explicitly set to false, this flag overrides other flags that make the kubectl commands apply to uninitialized objects, e.g., "--all". Objects with empty metadata.initializers are regarded as initialized.]' \
            '--now[If true, resources are signaled for immediate shutdown (same as --grace-period=1).]' \
            '(-o --output)'{-o,--output}'[Output format. One of:json|yaml|wide|name|custom-columns=...|custom-columns-file=...|go-template=...|go-template-file=...|jsonpath=...|jsonpath-file=...See custom columns \[http://kubernetes.io/docs/user-guide/kubectl-overview/#custom-columns\], golang template \[http://golang.org/pkg/text/template/#pkg-overview\] and jsonpath template \[http://kubernetes.io/docs/user-guide/jsonpath\].]:output_flag:__output_flag' \
            '(-R --recursive)'{-R,--recursive}'[Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests organized within the same directory.]' \
            '(-l --selector)'{-l,--selector}'[Selector (label query) to filter on, supports '\''='\'', '\''=='\'', and '\''!='\''.(e.g. -l key1=value1,key2=value2)]' \
            '--timeout[The length of time to wait before giving up on a delete, zero means determine a timeout from the size of the object]' \
            '--wait[If true, wait for resources to be gone before returning. This waits for finalizers.]' \
            "1: :{_alternative ':get_resources:__kube_get_api_resources delete' }" \
            "2: :{_alternative ':get_resources:__hook_api_resources'}" && ret=0
        ;;

        rollout)
          _arguments \
            ${_global_flags[@]} \
            "1: :{_alternative ':rollout_cmd:__rollout_cmd' }" \
            "2: :{_alternative ':rollout_resources:__kube_rollout_resources2name'}" && ret=0
        ;;

        scale)
          _arguments \
            ${_global_flags[@]} \
            '--all[Select all resources in the namespace of the specified resource types]' \
            '--allow-missing-template-keys[If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to golang and jsonpath output formats.]' \
            '--current-replicas[Precondition for current size. Requires that the current size of the resource match this value in order to scale.]' \
            '(-f --filename)'{-f,--filename}'[Filename, directory, or URL to files identifying the resource to set a new size]:files:_files' \
            '(-o --output)'{-o,--output}'[Output format. One of:json|yaml|name|go-template|go-template-file|template|templatefile|jsonpath|jsonpath-file.]:output_flag:__output_flag' \
            '(-R --recursive)'{-R,--recursive}'[Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests organized within the same directory.]' \
            '--resource-version[Requires that the current resource version match this value in order to scale.]' \
            '(-l --selector)'{-l,--selector}'[Selector (label query) to filter on, supports '\''='\'', '\''=='\'', and '\''!='\''.(e.g. -l key1=value1,key2=value2)]' \
            '--template[Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format is golang templates \[http://golang.org/pkg/text/template/#pkg-overview\].]' \
            '--timeout[The length of time to wait before giving up on a scale operation, zero means don'\''t wait. Any other values should contain a corresponding time unit (e.g. 1s, 2m, 3h).]' \
            "1: :{_alternative ':scale_cmd:__scale_cmd' }"  && ret=0
        ;;

        autoscale)
          _arguments \
            ${_global_flags[@]} \
            '--allow-missing-template-keys[If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to golang and jsonpath output formats.]' \
            '--cpu-percent[The target average CPU utilization (represented as a percent of requested CPU) over all the pods. If it'\''s not specified or negative, a default autoscaling policy will be used.]' \
            '--dry-run[If true, only print the object that would be sent, without sending it.]' \
            '(-f --filename)'{-f,--filename}'[Filename, directory, or URL to files identifying the resource to autoscale.]:files:_files' \
            '--generator[The name of the API generator to use. Currently there is only 1 generator.]' \
            '--max[The upper limit for the number of pods that can be set by the autoscaler. Required.]' \
            '--min[The lower limit for the number of pods that can be set by the autoscaler. If it'\''s not specified or negative, the server will apply a default value.]' \
            '--name[The name for the newly created object. If not specified, the name of the input resource will be used.]' \
            '(-o --output)'{-o,--output}'[Output format. One of:json|yaml|name|go-template-file|templatefile|template|go-template|jsonpath|jsonpath-file.]:output_flag:__output_flag' \
            '--record[Record current kubectl command in the resource annotation. If set to false, do not record the command. If set to true, record the command. If not set, default to updating the existing annotation value only if one already exists.]' \
            '(-R --recursive)'{-R,--recursive}'[Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests organized within the same directory.]' \
            '--save-config[If true, the configuration of current object will be saved in its annotation. Otherwise, the annotation will be unchanged. This flag is useful when you want to perform kubectl apply on this object in the future.]' \
            '--template[Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format is golang templates \[http://golang.org/pkg/text/template/#pkg-overview\].]' \
            "1: :{_alternative ':get_resources:__kube_get_api_resources autoscale' }" \
            "2: :{_alternative ':get_resources:__hook_api_resources'}" \
            "3: :{_alternative ':get_resources:__hook_autoscale_cmd'}" && ret=0
        ;;

        certificate)
          _arguments \
            ${_global_flags[@]} \
            "1: :{_alternative ':certificate_cmd:__certificate_cmd' }" && ret=0
        ;;

        cluster-info)
          _arguments \
            ${_global_flags[@]} \
            "1: :{_alternative ':clusterinfo_cmd:__clusterinfo_cmd' }" && ret=0
        ;;

        top)
          _arguments \
            ${_global_flags[@]} \
            "1: :{_alternative ':top_cmd:__top_cmd' }" && ret=0
        ;;

        cordon)
          _arguments \
            ${_global_flags[@]} \
            '--dry-run[If true, only print the object that would be sent, without sending it.]' \
            '(-l --selector)'{-l,--selector}'[Selector (label query) to filter on]' \
            "1: :{_alternative ':cordon_node:__kube_get_nodes' }" && ret=0
        ;;

        uncordon)
          _arguments \
            ${_global_flags[@]} \
            '--dry-run[If true, only print the object that would be sent, without sending it.]' \
            '(-l --selector)'{-l,--selector}'[Selector (label query) to filter on]' \
            "1: :{_alternative ':uncordon_node:__kube_get_nodes' }" && ret=0
        ;;

        drain)
          _arguments \
            ${_global_flags[@]} \
            '--delete-local-data[Continue even if there are pods using emptyDir (local data that will be deleted when the node is drained).]' \
            '--dry-run[If true, only print the object that would be sent, without sending it.]' \
            '--force[Continue even if there are pods not managed by a ReplicationController, ReplicaSet, Job, DaemonSet or StatefulSet.]' \
            '--grace-period[Period of time in seconds given to each pod to terminate gracefully. If negative, the default value specified in the pod will be used.]' \
            '--ignore-daemonsets[Ignore DaemonSet-managed pods.]' \
            '--pod-selector[Label selector to filter pods on the node]' \
            '(-l --selector)'{-l,--selector}'[Selector (label query) to filter on, supports '\''='\'', '\''=='\'', and '\''!='\''.(e.g. -l key1=value1,key2=value2)]' \
            '--timeout[The length of time to wait before giving up, zero means infinite]' \
            "1: :{_alternative ':drain_node:__kube_get_nodes' }" && ret=0
        ;;

        taint)
          _arguments \
            ${_global_flags[@]} \
            '--all[Select all nodes in the cluster]' \
            '--allow-missing-template-keys[If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to golang and jsonpath output formats.]' \
            '(-o --output)'{-o,--output}'[Output format. One of:json|yaml|name|go-template-file|templatefile|template|go-template|jsonpath|jsonpath-file.]:output_flag:__output_flag' \
            '--overwrite[If true, allow taints to be overwritten, otherwise reject taint updates that overwrite existing taints.]' \
            '(-l --selector)'{-l,--selector}'[Selector (label query) to filter on, supports '\''='\'', '\''=='\'', and '\''!='\''.(e.g. -l key1=value1,key2=value2)]' \
            '--template[Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format is golang templates \[http://golang.org/pkg/text/template/#pkg-overview\].]' \
            '--validate[If true, use a schema to validate the input before sending it]' \
            "1: :{_alternative ':taint_node:__kube_get_nodes' }" && ret=0
        ;;

        describe)
          _arguments \
            ${_global_flags[@]} \
            '--all-namespaces[If present, list the requested object(s) across all namespaces. Namespace in current context is ignored even if specified with --namespace.]' \
            '(-f --filename)'{-f,--filename}'[Filename, directory, or URL to files containing the resource to describe]:files:_files' \
            '--include-uninitialized[If true, the kubectl command applies to uninitialized objects. If explicitly set to false, this flag overrides other flags that make the kubectl commands apply to uninitialized objects, e.g., "--all". Objects with empty metadata.initializers are regarded as initialized.]' \
            '(-R --recursive)'{-R,--recursive}'[Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests organized within the same directory.]' \
            '(-l --selector)'{-l,--selector}'[Selector (label query) to filter on, supports '\''='\'', '\''=='\'', and '\''!='\''.(e.g. -l key1=value1,key2=value2)]' \
            '--show-events[If true, display events related to the described object.]' \
            "1: :{_alternative ':get_resources:__kube_get_api_resources describe' }" \
            "2: :{_alternative ':get_resources:__hook_api_resources'}" && ret=0
        ;;

        logs)
          _arguments \
            ${_global_flags[@]} \
            '--all-containers[Get all containers'\''s logs in the pod(s).]' \
            '(-c --container)'{-c,--container}'[Print the logs of this container]' \
            '(-f --follow)'{-f,--follow}'[Specify if the logs should be streamed.]' \
            '--limit-bytes[Maximum bytes of logs to return. Defaults to no limit.]' \
            '--pod-running-timeout[The length of time (like 5s, 2m, or 3h, higher than zero) to wait until at least one pod is running]' \
            '(-p --previous)'{-p,--previous}'[If true, print the logs for the previous instance of the container in a pod if it exists.]' \
            '(-l --selector)'{-l,--selector}'[Selector (label query) to filter on, supports '\''='\'', '\''=='\'', and '\''!='\''.(e.g. -l key1=value1,key2=value2)]' \
            '--since[Only return logs newer than a relative duration like 5s, 2m, or 3h. Defaults to all logs. Only one of since-time / since may be used.]' \
            '--since-time[Only return logs after a specific date (RFC3339). Defaults to all logs. Only one of since-time / since may be used.]' \
            '--tail[Lines of recent log file to display. Defaults to -1 with no selector, showing all log lines otherwise 10, if a selector is provided.]' \
            '--timestamps[Include timestamps on each line in the log output]' \
            "1: :{_alternative ':get_resources:__kube_get_api_resources2name logs' }" && ret=0
        ;;

        attach)
          _arguments \
            ${_global_flags[@]} \
            '(-c --container)'{-c,--container}'[Container name. If omitted, the first container in the pod will be chosen]' \
            '--pod-running-timeout[The length of time (like 5s, 2m, or 3h, higher than zero) to wait until at least one pod is running]' \
            '(-i --stdin)'{-i,--stdin}'[Pass stdin to the container]' \
            '(-t --tty)'{-t,--tty}'[Stdin is a TTY]' \
            "1: :{_alternative ':log_pods:__kube_get_pods' }" && ret=0
        ;;

        exec)
          _arguments \
            ${_global_flags[@]} \
            '(-c --container)'{-c,--container}'[Container name. If omitted, the first container in the pod will be chosen]' \
            '(-i --stdin)'{-i,--stdin}'[Pass stdin to the container]' \
            '(-t --tty)'{-t,--tty}'[Stdin is a TTY]' \
            "1: :{_alternative ':log_pods:__kube_get_pods' }" && ret=0
        ;;

        port-forward)
          _arguments \
            ${_global_flags[@]} \
            '--pod-running-timeout[The length of time (like 5s, 2m, or 3h, higher than zero) to wait until at least one pod is running]' \
            "1: :{_alternative ':get_resources:__kube_get_api_resources2name port-forward' }" && ret=0
        ;;

        proxy)
          _arguments \
            ${_global_flags[@]} \
            '--address[Addresses to listen on (comma separated)]' \
            '--api-prefix[The length of time (like 5s, 2m, or 3h, higher than zero) to wait until at least one pod is running.]' && ret=0
        ;;

        cp)
          _arguments \
            ${_global_flags[@]} \
            '(-c --container)'{-c,--container}'[Container name. If omitted, the first container in the pod will be chosen]' \
            '--no-preserve[The copied file/directory'\''s ownership and permissions will not be preserved in the container]' && ret=0
        ;;

        auth)
          _arguments \
            ${_global_flags[@]} \
            "1: :{_alternative ':auth_cmd:__auth_cmd' }" && ret=0
        ;;

        apply)
          _values 'kubectl apply -f FILENAME [options]' \
            ${_global_flags[@]} \
            '--all[Select all resources in the namespace of the specified resource types.]' \
            '--allow-missing-template-keys[If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to golang and jsonpath output formats.]' \
            '--cascade[If true, cascade the deletion of the resources managed by this resource (e.g. Pods created by a ReplicationController).  Default true.]' \
            '--dry-run[If true, only print the object that would be sent, without sending it.]' \
            '(-f --filename)'{-f,--filename}'[that contains the configuration to apply]:files:_files' \
            '--force[Only used when grace-period=0. If true, immediately remove resources from API and bypass graceful deletion. Note that immediate deletion of some resources may result in inconsistency or data loss and requires confirmation.]' \
            '--grace-period[Period of time in seconds given to the resource to terminate gracefully. Ignored if negative. Set to 1 for immediate shutdown. Can only be set to 0 when --force is true (force deletion).]' \
            '--include-uninitialized[If true, the kubectl command applies to uninitialized objects. If explicitly set to false, this flag overrides other flags that make the kubectl commands apply to uninitialized objects, e.g., \"--all\". Objects with empty metadata.initializers are regarded as initialized.]' \
            '--openapi-patch[If true, use openapi to calculate diff when the openapi presents and the resource can be found in the openapi spec. Otherwise, fall back to use baked-in types.]' \
            '(-o --output)'{-o,--output}'[Output format. One of:json|yaml|name|go-template-file|templatefile|template|go-template|jsonpath|jsonpath-file.]:output_flag:__output_flag' \
            '--overwrite[Automatically resolve conflicts between the modified and live configuration by using values from the modified configuration]' \
            '--prune[Automatically delete resource objects, including the uninitialized ones, that do not appear in the configs and are created by either apply or create --save-config. Should be used with either -l or --all.]' \
            '--prune-whitelist[Overwrite the default whitelist with <group/version/kind> for --prune]' \
            '--record[Record current kubectl command in the resource annotation. If set to false, do not record the command. If set to true, record the command. If not set, default to updating the existing annotation value only if one already exists.]' \
            '(-R --recursive)'{-R,--recursive}'[Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests organized within the same directory.]' \
            '(-l --selector)'{-l,--selector}'[Selector (label query) to filter on, supports '\''='\'', '\''=='\'', and '\''!='\''.(e.g. -l key1=value1,key2=value2)]' \
            '--template[Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format is golang templates \[http://golang.org/pkg/text/template/#pkg-overview\].]' \
            '--timeout[The length of time to wait before giving up on a delete, zero means determine a timeout from the size of the object]' \
            '--validate[If true, use a schema to validate the input before sending it]' \
            '--wait[If true, wait for resources to be gone before returning. This waits for finalizers.]' \
            'edit-last-applied[Edit latest last-applied-configuration annotations of a resource/object]' \
            'set-last-applied[Set the last-applied-configuration annotation on a live object to match the contents of a file.]' \
            'view-last-applied[View latest last-applied-configuration annotations of a resource/object]' && ret=0
       ;;

        patch)
          _arguments \
            ${_global_flags[@]} \
            '--allow-missing-template-keys[If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to golang and jsonpath output formats.]' \
            '--dry-run[If true, only print the object that would be sent, without sending it.]' \
            '(-f --filename)'{-f,--filename}'[Filename, directory, or URL to files identifying the resource to update]:files:_files' \
            '--local[If true, patch will operate on the content of the file, not the server-side resource.]' \
            '(-o --output)'{-o,--output}'[Output format. One of:json|yaml|name|go-template-file|templatefile|template|go-template|jsonpath|jsonpath-file.]:output_flag:__output_flag' \
            '(-p --patch)'{-p,--patch}'[The patch to be applied to the resource JSON file.]' \
            '--record[Record current kubectl command in the resource annotation. If set to false, do not record the command. If set to true, record the command. If not set, default to updating the existing annotation value only if one already exists.]' \
            '(-R --recursive)'{-R,--recursive}'[Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests organized within the same directory.]' \
            '--template[Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format is golang templates \[http://golang.org/pkg/text/template/#pkg-overview\].]' \
            '--type[The type of patch being provided; one of \[json merge strategic\]]' \
            "1: :{_alternative ':get_resources:__kube_get_api_resources patch' }" && ret=0
        ;;
        replace)
          _arguments \
            ${_global_flags[@]} \
            '--allow-missing-template-keys[If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to golang and jsonpath output formats.]' \
            '--cascade[If true, cascade the deletion of the resources managed by this resource (e.g. Pods created by a ReplicationController).  Default true.]' \
            '(-f --filename)'{-f,--filename}'[to use to replace the resource.]' \
            '--force[If true, immediately remove resources from API and bypass graceful deletion. Note that immediate deletion of some resources may result in inconsistency or data loss and requires confirmation.]' \
            '--grace-period[Period of time in seconds given to the resource to terminate gracefully. Ignored if negative. Set to 1 for immediate shutdown. Can only be set to 0 when --force is true (force deletion).]' \
            '(-o --output)'{-o,--output}'[Output format. One of:json|yaml|name|go-template-file|templatefile|template|go-template|jsonpath|jsonpath-file.]:output_flag:__output_flag' \
            '(-R --recursive)'{-R,--recursive}'[Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests organized within the same directory.]' \
            '--save-config[If true, the configuration of current object will be saved in its annotation. Otherwise, the annotation will be unchanged. This flag is useful when you want to perform kubectl apply on this object in the future.]' \
            '--template[Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format is golang templates \[http://golang.org/pkg/text/template/#pkg-overview\].]' \
            '--timeout[The length of time to wait before giving up on a delete, zero means determine a timeout from the size of the object]' \
            '--validate[If true, use a schema to validate the input before sending it]' \
            '--wait[If true, wait for resources to be gone before returning. This waits for finalizers.]' && ret=0
        ;;
        wait)
          _arguments \
            ${_global_flags[@]} \
            '--all-namespaces[If present, list the requested object(s) across all namespaces. Namespace in current context is ignored even if specified with --namespace.]' \
            '--allow-missing-template-keys[If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to golang and jsonpath output formats.]' \
            '(-f --filename)'{-f,--filename}'[to use to replace the resource.]' \
            '--for[The condition to wait on: \[delete\|condition=condition-name\].]' \
            '(-o --output)'{-o,--output}'[Output format. One of:json|yaml|name|go-template-file|templatefile|template|go-template|jsonpath|jsonpath-file.]:output_flag:__output_flag' \
            '(-R --recursive)'{-R,--recursive}'[Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests organized within the same directory.]' \
            '(-l --selector)'{-l,--selector}'[Selector (label query) to filter on, supports '\''='\'', '\''=='\'', and '\''!='\''.(e.g. -l key1=value1,key2=value2)]' \
            '--template[Template string or path to template file to use when -o=go-template, -o=go-template-file. The template format is golang templates \[http://golang.org/pkg/text/template/#pkg-overview\].]' \
            '--timeout[The length of time to wait before giving up on a delete, zero means determine a timeout from the size of the object]' && ret=0
            "1: :{_alternative ':get_resources:__kube_get_api_resources2name wait' }" && ret=0
        ;;
        convert)
          _arguments \
           ${_global_flags[@]} \
           '--allow-missing-template-keys[If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to golang and jsonpath output formats.]' \
           '(-f --filename)'{-f,--filename}'[Filename, directory, or URL to files to need to get converted.]' \
           '--local[If true, convert will NOT try to contact api-server but run locally.]' \
           '(-o --output)'{-o,--output}'[Output format. One of:json|yaml|name|go-template-file|templatefile|template|go-template|jsonpath|jsonpath-file.]:output_flag:__output_flag' \
           '--output-version[Output the formatted object with the given group version (for ex:'\''extensions/v1beta1'\'').)]' \
           '(-R --recursive)'{-R,--recursive}'[Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests organized within the same directory.]' \
           '--template[Template string or path to template file to use when -o=go-template,-o=go-template-file. The template format is golang templates \[http://golang.org/pkg/text/template/#pkg-overview\].]' \
           '--validate[If true, use a schema to validate the input before sending it]' && ret=0
        ;;
        label)
          _arguments \
            ${_global_flags[@]} \
            '--all[Select all resources, including uninitialized ones, in the namespace of the specified resource types]' \
            '--allow-missing-template-keys[If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to golang and jsonpath output formats.]' \
            '--dry-run[If true, only print the object that would be sent, without sending it.]' \
            '--field-selector[Selector (field query) to filter on, supports '\''='\'', '\''=='\'', and '\''!='\''.(e.g. -l key1=value1,key2=value2)]' \
            '(-f --filename)'{-f,--filename}'[Filename, directory, or URL to files identifying the resource to update the labels]' \
            '--include-uninitialized[If true, the kubectl command applies to uninitialized objects. If explicitly set to false, this flag overrides other flags that make the kubectl commands apply to uninitialized objects, e.g., \"\-\-all\". Objects with empty metadata.initializers are regarded as initialized.]' \
            '--list[If true, display the labels for a given resource.]' \
            '--local[If true, label will NOT contact api-server but run locally.]' \
            '(-o --output)'{-o,--output}'[Output format. One of:json|yaml|name|go-template-file|templatefile|template|go-template|jsonpath|jsonpath-file.]:output_flag:__output_flag' \
            '--overwrite[If true, allow labels to be overwritten, otherwise reject label updates that overwrite existing labels.]' \
            '--record[Record current kubectl command in the resource annotation. If set to false, do not record the command. If set to true, record the command. If not set, default to updating the existing annotation value only if one already exists.]' \
            '(-R --recursive)'{-R,--recursive}'[Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests organized within the same directory.]' \
            '--resource-version[If non-empty, the labels update will only succeed if this is the current resource-version for the object. Only valid when specifying a single resource.]' \
            '(-l --selector)'{-l,--selector}'[Selector (label query) to filter on, supports '\''='\'', '\''=='\'', and '\''!='\''.(e.g. -l key1=value1,key2=value2)]' \
            '--template[Template string or path to template file to use when -o=go-template,-o=go-template-file. The template format is golang templates \[http://golang.org/pkg/text/template/#pkg-overview\].]' \
            "1: :{_alternative ':get_resources:__kube_get_api_resources label' }" \
            "2: :{_alternative ':get_resources:__hook_api_resources'}" && ret=0
        ;;
        annotate)
          _arguments \
            ${_global_flags[@]} \
            '--all[Select all resources, including uninitialized ones, in the namespace of the specified resource types]' \
            '--allow-missing-template-keys[If true, ignore any errors in templates when a field or map key is missing in the template. Only applies to golang and jsonpath output formats.]' \
            '--dry-run[If true, only print the object that would be sent, without sending it.]' \
            '--field-selector[Selector (field query) to filter on, supports '\''='\'', '\''=='\'', and '\''!='\''.(e.g. -l key1=value1,key2=value2)]' \
            '(-f --filename)'{-f,--filename}'[Filename, directory, or URL to files identifying the resource to update the labels]' \
            '--include-uninitialized[If true, the kubectl command applies to uninitialized objects. If explicitly set to false, this flag overrides other flags that make the kubectl commands apply to uninitialized objects, e.g., \"\-\-all\". Objects with empty metadata.initializers are regarded as initialized.]' \
            '--list[If true, display the labels for a given resource.]' \
            '--local[If true, label will NOT contact api-server but run locally.]' \
            '(-o --output)'{-o,--output}'[Output format. One of:json|yaml|name|go-template-file|templatefile|template|go-template|jsonpath|jsonpath-file.]:output_flag:__output_flag' \
            '--overwrite[If true, allow labels to be overwritten, otherwise reject label updates that overwrite existing labels.]' \
            '--record[Record current kubectl command in the resource annotation. If set to false, do not record the command. If set to true, record the command. If not set, default to updating the existing annotation value only if one already exists.]' \
            '(-R --recursive)'{-R,--recursive}'[Process the directory used in -f, --filename recursively. Useful when you want to manage related manifests organized within the same directory.]' \
            '--resource-version[If non-empty, the labels update will only succeed if this is the current resource-version for the object. Only valid when specifying a single resource.]' \
            '(-l --selector)'{-l,--selector}'[Selector (label query) to filter on, supports '\''='\'', '\''=='\'', and '\''!='\''.(e.g. -l key1=value1,key2=value2)]' \
            '--template[Template string or path to template file to use when -o=go-template,-o=go-template-file. The template format is golang templates \[http://golang.org/pkg/text/template/#pkg-overview\].]' \
            "1: :{_alternative ':get_resources:__kube_get_api_resources annotate' }" \
            "2: :{_alternative ':get_resources:__hook_api_resources'}" && ret=0
       ;;
       completion)
         _arguments \
           ${_global_flags[@]} \
           "1: :{_alternative ':completion_cmd:__completion_cmd' }" && ret=0
       ;;
       #  No alpha commands are available in this version of kubectl
       #  alpha)
       #    _arguments \
       #      ${_global_flags[@]} \
       #      "1: :{_alternative ':alpha_cmd:__alpha_cmd' }" && ret=0
       #;;
       api-resources)
         _arguments \
           ${_global_flags[@]} \
           '--api-group[Limit to resources in the specified API group.]' \
           '--cached[Use the cached list of resources if available.]' \
           '--namespaced[If false, non-namespaced resources will be returned, otherwise returning namespaced resources by default]' \
           '--no-headers[When using the default or custom-column output format, don'\''t print headers(default print headers).]' \
           '(-o --output)'{-o,--output}'[Output format. One of: wide|name.]:output_flag:__output_flag' \
           '--verbs[Limit to resources that support the specified verbs.]' && ret=0
       ;;
       api-versions)
         _arguments \
           ${_global_flags[@]} && ret=0
       ;;
       config)
          _arguments \
            ${_global_flags[@]} \
            "1: :{_alternative ':config_cmd:__config_cmd' }" && ret=0
       ;;
       plugin)
         _arguments \
           ${_global_flags[@]} \
           "1: :{_alternative ':plugin_cmd:__plugin_cmd' }" && ret=0
       ;;
       version)
         _arguments \
           ${_global_flags[@]} \
           '--client[Client version only (no server required).]' \
           '(-o --output)'{-o,--output}'[One of '\''yaml'\'' or '\''json'\'']:output_flag:__output_flag' \
           '--short[Print just the version number.]' && ret=0
       ;;
      esac
    ;;
  esac

  return ret
}
