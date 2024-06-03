# kg-inventory

## Dependencies
- [kg-core](https://github.com/kgcore-framework/kg-core)
- [kg-logs](https://github.com/kgcore-framework/kg-logs) - For logging transfer and other history

## Features
- Stashes (Personal and/or Shared)
- Vehicle Trunk & Glovebox
- Weapon Attachments
- Shops
- Item Drops

## Documentation
https://docs.kgcore.org/kgcore-documentation/kgcore-resources/kg-inventory

## Installation
### Manual
- Download the script and put it in the `[kg]` directory.
- Import `kg-inventory.sql` in your database
- Add the following code to your server.cfg/resouces.cfg

# Migrating from old kg-inventory

## Database
### Upload the new `inventory.sql` file to create the new `inventories` table
### Use the provided `migrate.sql` file to migrate all of your saved inventory data from stashes, trunks, etc
### Once complete, you can delete `gloveboxitems` `stashitems` and `trunkitems` tables from your database
```sql
CREATE TABLE IF NOT EXISTS `inventories` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `identifier` VARCHAR(50) NOT NULL,
  `items` LONGTEXT DEFAULT ('[]'),
  PRIMARY KEY (`identifier`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4;
```

# License

    KGCore Framework
    Copyright (C) 2023 Knuckls

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>
