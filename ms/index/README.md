# Indexes

# Type of indexes

The are many indexes, each designed to perform well for different purposes. They are implemented slightly differently on different storage engines despite they have the same name.

## B Tree (technically B+ tree)

In Mysql, InnoDB uses B+ Tree

**Types of queries that can use a B-Tree index:** B-tree indexes work well by the full key value, a key range, or a key prefix. They are also useful if the lookup uses a leftmost prefix of the index.

- Match the full value
- Match the left-most prefix
- Match the range queries
- Match one part exactly and match a range on another part
- Index only queries

************************Limitations:************************

- They are not useful if the lookup does not start from the leftmost side of the indexed
columns.
- You can’t skip columns in the index
- The storage engine can’t optimize accesses with any columns to the right of the
first range condition

## Hash Index

## R Tree

# Benefits of indexes

1. Indexes reduce the amount of data the server has to examine.

2. Indexes help the server avoid sorting and temporary tables. 

3. Indexes turn random I/O into sequential I/O. (clustered index)

# Questions