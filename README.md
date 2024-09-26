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
DNSprop A:frosit.nl
```

and provide multiple types/domains.

```bash
DNSprop A:frosit.nl CNAME:www.frosit.nl

# @todo add result
```

provide a expected value (@TODO)

```bash
DNSprop A:frosit.nl:127.0.0.1 CNAME:www.frosit.nl:myserver.something.nl

# @todo add result
```

Use operators for your expected value (usefull with multiple records) (@TODO)

```bash
DNSprop A:frosit.nl:!127.0.0.1 CNAME:www.frosit.nl:~myserver.something.nl TXT:mail.something.com:!~oldmailserver.nl

# @todo add result
```