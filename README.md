DNSprop - A simple DNS propagation check script to help with DNS-related maintenance tasks
===============================================================

DNSProp is meant to help with server migration or other DNS related tasks where you need to monitor DNS propagation.
It allows you to check certain DNS records against various global DNS servers so you can easily determine whether DNS changes have propagated (become active).

**Use cases**

* Server migration
* DNS changes
* moving to another registrat

**example**

```bash
DNSprop A:frosit.nl CNAME:www.frosit.nl

# @todo add result
```

# Installation

```bash
curl .... github.com/.../install.sh # @todo
```

# Usage

In it's simplest from you can provide a domain name and DNSprop will use [dig](#) to ask various DNS servers what records it holds and shows you.

```bash
DNSprop frosit.nl
```

But you can also specify the type of record.

```bash
DNSprop A::frosit.nl
```

and provide multiple types/domains.

```bash
DNSprop A::frosit.nl CNAME::www.frosit.nl

# @todo add result
```

provide a expected value (@TODO)

```bash
DNSprop A::frosit.nl::127.0.0.1 CNAME::www.frosit.nl::=myserver.something.nl

# @todo add result
```

Use operators for your expected value (usefull with multiple records) (@TODO)

```bash
DNSprop A::frosit.nl::!127.0.0.1 CNAME::www.frosit.nl::WILDCARD'*myserver.something.nl*' TXT::mail.something.com::LIKE'v=spf% ip4:88.77.66.55 % -all' 
```

# Development

DNSProp is structured within the `/src` directory and can be compiled into a single file using `make compile`.

@TODO document requirements for make

@TODO development docs
  - vscode
  - devcontainer
  - bats
  - debugging
  - compiling
  - shellsheck
  - code docs

# About

This project was made by Fabio Ros of [FROSIT](https://frosit.nl).