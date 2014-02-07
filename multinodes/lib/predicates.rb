# -*- mode: ruby -*-
# vi: set ft=ruby :

def master?(name)
    return /^master/ =~ name
end

def slave?(name)
    return /^slave/ =~ name
end

def zk?(name)
    return /^zk/ =~ name
end