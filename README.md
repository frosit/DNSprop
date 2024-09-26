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


# Syntax


The DNSprop domain syntax uses the following structure.

`TYPE:HOST:EXPECT`

# TYPE

This can be _none_ or a [DNS record type](#somepage-about-dns-record-type)

**common types**

* A
* CNAME
* TXT
* SRV
* ....
* @TODO add more types


----------


# HOST

This is a _required field_ and should only include a [host](https://datatracker.ietf.org/doc/html/rfc3986#autoid-21) but may include a subdomain.

**good examples**

* mydomain.com
* www.domain.com
* help.support.domain.com

**bad examples**

* http://mydomain.com
* mydomain
* user:pwd@mydomain.com
* mydomain.com/subdirectory
* mydomain.com/index.php


---------



# EXPECT

Expect means you can provide what value to (or not to) expect when querying DNS servers. This is helpfull in combination with `--monitor` to continously run checks by for example a timeframe`--sleep=2mins` untill conditions are met.

the expect value can be for example, an IP address, a string, or part of a string (using the `~` like operator)

Expect can be split in 2 parts.

1. Operator
2. Expected value(s)

## Operators

* `!=` not equals
* `=` equals
* `+` contains / matches 1 or more
* `-` does not contain / matches 0

Multiple expect values can be provided using a double pipe `|`.

@TODO is a double pipe better for pasing?

```shell
DNSprop A:frosit.nl:=127.0.0.1||88.77.66.55.1||8.8.8.8
```

@TODO is a double `::` better for parsing on splitting the argument?

**LIKE operator**

Just like the MySQL `LIKE` operator, you can match using the following syntax.

```shell
DNSprop CNAME:frosit.nl:LIKE:www%.frosit.%

# matches
# www.internal.frosit.nl
# www.internal.frosit.com
# www.frosit.nl
```

**Regexp operator**

You can also specify a regexp string to match against.

```shell
DNSprop CNAME:frosit.nl:REGEXP=/(www\.|)frosit.(nl|com|it)/

# matches
# www.internal.frosit.nl
# www.internal.frosit.com
# www.frosit.nl
```

** operator**



**Regexp matching**

* @todo refer to regex101
* @todo which operator to use for regex match
  * @TODO check for proper regex operator (`%`?)
  * `~` like (string contains string)?

by default it's an exact match

**Usable operators**

* ~
* @
* #
* %
* &
* *