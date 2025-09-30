//// 🦭MariaDB dialect to be used in conjunction with the `shork` or `gmysql` libraries.
////

import cake
import cake/internal/dialect.{Maria}
import cake/internal/prepared_statement
import cake/internal/read_query
import cake/internal/write_query

// ┌───────────────────────────────────────────────────────────────────────────┐
// │ type re-exports                                                           │
// └───────────────────────────────────────────────────────────────────────────┘

pub type CakeQuery(a, param) =
  cake.CakeQuery(a, param)

pub type PreparedStatement(param) =
  prepared_statement.PreparedStatement(param)

pub type ReadQuery(param) =
  read_query.ReadQuery(param)

pub type WriteQuery(a, param) =
  write_query.WriteQuery(a, param)

/// Converts a cake query to a 🦭MariaDB prepared statement.
///
pub fn cake_query_to_prepared_statement(
  query qry: CakeQuery(a, param),
) -> PreparedStatement(param) {
  qry |> cake.to_prepared_statement(dialect: Maria)
}

/// Converts read query to a 🦭MariaDB prepared statement.
///
pub fn read_query_to_prepared_statement(
  query qry: ReadQuery(param),
) -> PreparedStatement(param) {
  qry |> cake.read_query_to_prepared_statement(dialect: Maria)
}

/// Converts a write query to a 🦭MariaDB prepared statement.
///
pub fn write_query_to_prepared_statement(
  query qry: WriteQuery(a, param),
) -> PreparedStatement(param) {
  qry |> cake.write_query_to_prepared_statement(dialect: Maria)
}
