//// 🐘PostgreSQL dialect to be used in conjunction with the `pog`
//// library.
////

import cake
import cake/internal/dialect.{Postgres}
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

/// Converts a cake query to a 🐘PostgreSQL prepared statement.
///
pub fn cake_query_to_prepared_statement(
  query qry: CakeQuery(a, param),
) -> PreparedStatement(param) {
  qry |> cake.to_prepared_statement(dialect: Postgres)
}

/// Converts read query to a 🐘PostgreSQL prepared statement.
///
pub fn read_query_to_prepared_statement(
  query qry: ReadQuery(param),
) -> PreparedStatement(param) {
  qry |> cake.read_query_to_prepared_statement(dialect: Postgres)
}

/// Converts a write query to a 🐘PostgreSQL prepared statement.
///
pub fn write_query_to_prepared_statement(
  query qry: WriteQuery(a, param),
) -> PreparedStatement(param) {
  qry |> cake.write_query_to_prepared_statement(dialect: Postgres)
}
