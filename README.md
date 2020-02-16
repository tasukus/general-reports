general-reports
===============

[![Build Status](https://secure.travis-ci.org/tasukus/general-reports.png)](http://travis-ci.org/tasukus/general-reports)

Report structure
----------------

Typically, one general report contains:

1. sqlcontent.sql (MMEX will execute this SQL first to return one result set)

   ~~~sql
   select * from assets;
   ~~~

2. luacontent.lua (There are two APIs here)
   * handle_record

   ~~~lua
   function handle_record(record)
     -- Your logic to modify a record and apply this function against every record from SQL.
     record:set("extra_value", record::get("VALUE") * 2);
   end
   ~~~

   * complete

   ~~~lua
   function complete(result)
     -- Put some accumulated value and apply this function after SQL completes.
     result:set("TOTAL", 1000);
   end
   ~~~

3. template.htt (a plain text template file powered by [html template](https://github.com/moneymanagerex/html-template) which shares the same syntax with Perl's [HTML::Template](http://search.cpan.org/~wonko/HTML-Template-2.95/lib/HTML/Template.pm))
