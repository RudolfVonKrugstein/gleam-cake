//// A DSL to build combined queries, such as:
////
//// - `UNION`
//// - `UNION ALL`
//// - `EXCEPT`
//// - `EXCEPT ALL`
//// - `INTERSECT`
//// - `INTERSECT ALL`
////
//// ## Compatibility
////
//// - 🪶SQLite does not support `EXCEPT ALL` and `INTERSECT ALL`.
////

import cake/internal/read_query.{
  Combined, CombinedQuery, Comment, Epilog, ExceptAll, ExceptDistinct,
  IntersectAll, IntersectDistinct, NoComment, NoEpilog, NoLimit, NoOffset,
  NoOrderBy, OrderBy, OrderByColumn, UnionAll, UnionDistinct,
}
import gleam/string

// ┌───────────────────────────────────────────────────────────────────────────┐
// │  read_query type re-exports                                               │
// └───────────────────────────────────────────────────────────────────────────┘

pub type Combined(param) =
  read_query.Combined(param)

pub type Comment =
  read_query.Comment

pub type Epilog =
  read_query.Epilog

pub type Limit =
  read_query.Limit

pub type Offset =
  read_query.Offset

pub type OrderBy(param) =
  read_query.OrderBy(param)

pub type OrderByDirection =
  read_query.OrderByDirection

pub type ReadQuery(param) =
  read_query.ReadQuery(param)

pub type Select(param) =
  read_query.Select(param)

/// Creates a `ReadQuery` from a `Combined` read_query.
///
pub fn to_query(combined cmbnd: Combined(param)) -> ReadQuery(param) {
  cmbnd |> CombinedQuery
}

// ▒▒▒ Combined Kind ▒▒▒

/// Creates a `UNION` query out of two queries as a `Combined` `ReadQuery`.
///
pub fn union(
  query_a qry_a: Select(param),
  query_b qry_b: Select(param),
) -> Combined(param) {
  UnionDistinct |> read_query.combined_query_new([qry_a, qry_b])
}

/// Creates a `UNION` query out of two or more queries as a `Combined`
/// `ReadQuery`.
///
pub fn unions(
  query_a qry_a: Select(param),
  query_b qry_b: Select(param),
  more_queries mr_qrys: List(Select(param)),
) -> Combined(param) {
  UnionDistinct |> read_query.combined_query_new([qry_a, qry_b, ..mr_qrys])
}

/// Creates a `UNION ALL` query out of two queries as a `Combined` `ReadQuery`.
///
pub fn union_all(
  query_a qry_a: Select(param),
  query_b qry_b: Select(param),
) -> Combined(param) {
  UnionAll |> read_query.combined_query_new([qry_a, qry_b])
}

/// Creates a `UNION ALL` query out of two or more queries as a `Combined`
/// `ReadQuery`.
///
/// NOTICE: Not supported by 🪶SQLite.
///
pub fn unions_all(
  query_a qry_a: Select(param),
  query_b qry_b: Select(param),
  more_queries mr_qrys: List(Select(param)),
) -> Combined(param) {
  UnionAll |> read_query.combined_query_new([qry_a, qry_b, ..mr_qrys])
}

/// Creates an `EXCEPT` query out of two queries as a `Combined` `ReadQuery`.
///
pub fn except(
  query_a qry_a: Select(param),
  query_b qry_b: Select(param),
) -> Combined(param) {
  ExceptDistinct |> read_query.combined_query_new([qry_a, qry_b])
}

/// Creates an `EXCEPT` query out of two or more queries as a `Combined`
/// `ReadQuery`.
///
pub fn excepts(
  query_a qry_a: Select(param),
  query_b qry_b: Select(param),
  more_queries mr_qrys: List(Select(param)),
) -> Combined(param) {
  ExceptDistinct |> read_query.combined_query_new([qry_a, qry_b, ..mr_qrys])
}

/// Creates an `EXCEPT ALL` query out of two queries as a `Combined`
/// `ReadQuery`.
///
/// NOTICE: Not supported by 🪶SQLite.
///
pub fn except_all(
  query_a qry_a: Select(param),
  query_b qry_b: Select(param),
) -> Combined(param) {
  ExceptAll |> read_query.combined_query_new([qry_a, qry_b])
}

/// Creates an `EXCEPT ALL` query out of two or more queries as a `Combined`
/// `ReadQuery`.
///
/// NOTICE: Not supported by 🪶SQLite.
///
pub fn excepts_all(
  query_a qry_a: Select(param),
  query_b qry_b: Select(param),
  more_queries mr_qrys: List(Select(param)),
) -> Combined(param) {
  ExceptAll |> read_query.combined_query_new([qry_a, qry_b, ..mr_qrys])
}

/// Creates an `INTERSECT` query out of two queries as a `Combined` `ReadQuery`.
///
pub fn intersect(
  query_a qry_a: Select(param),
  query_b qry_b: Select(param),
) -> Combined(param) {
  IntersectDistinct |> read_query.combined_query_new([qry_a, qry_b])
}

/// Creates an `INTERSECT` query out of two or more queries as a `Combined`
/// read_query.
///
pub fn intersects(
  query_a qry_a: Select(param),
  query_b qry_b: Select(param),
  more_queries mr_qrys: List(Select(param)),
) -> Combined(param) {
  IntersectDistinct |> read_query.combined_query_new([qry_a, qry_b, ..mr_qrys])
}

/// Creates an `INTERSECT ALL` query out of two queries as a `Combined`
/// `ReadQuery`.
///
/// NOTICE: Not supported by 🪶SQLite.
///
pub fn intersect_all(
  query_a qry_a: Select(param),
  query_b qry_b: Select(param),
) -> Combined(param) {
  IntersectAll |> read_query.combined_query_new([qry_a, qry_b])
}

/// Creates an `INTERSECT ALL` query out of two or more queries as a `Combined`
/// `ReadQuery`.
///
/// NOTICE: Not supported by 🪶SQLite.
///
pub fn intersects_all(
  query_a qry_a: Select(param),
  query_b qry_b: Select(param),
  more_queries mr_qrys: List(Select(param)),
) -> Combined(param) {
  IntersectAll |> read_query.combined_query_new([qry_a, qry_b, ..mr_qrys])
}

/// Gets the queries from a `Combined` `ReadQuery`.
///
pub fn get_queries(combined cmbnd: Combined(param)) -> List(Select(param)) {
  cmbnd.queries
}

// ▒▒▒ LIMIT & OFFSET ▒▒▒

/// Sets a `Limit` in the `Combined` `ReadQuery`.
///
pub fn limit(query qry: Combined(param), limit lmt: Int) -> Combined(param) {
  let lmt = lmt |> read_query.limit_new
  Combined(..qry, limit: lmt)
}

/// Removes `Limit` from the `Combined` `ReadQuery`.
///
pub fn no_limit(query qry: Combined(param)) -> Combined(param) {
  Combined(..qry, limit: NoLimit)
}

/// Gets `Limit` in the `Combined` `ReadQuery`.
///
pub fn get_limit(query qry: Combined(param)) -> Limit {
  qry.limit
}

/// Sets an `Offset` in the `Combined` `ReadQuery`.
///
pub fn offset(query qry: Combined(param), offest offst: Int) -> Combined(param) {
  let offst = offst |> read_query.offset_new
  Combined(..qry, offset: offst)
}

/// Removes `Offset` from the `Combined` `ReadQuery`.
///
pub fn no_offset(query qry: Combined(param)) -> Combined(param) {
  Combined(..qry, offset: NoOffset)
}

/// Gets `Offset` in the `Combined` `ReadQuery`.
///
pub fn get_offset(query qry: Combined(param)) -> Offset {
  qry.offset
}

// ▒▒▒ ORDER BY ▒▒▒

/// Defines the direction of an `OrderBy`.
///
pub type Direction {
  Asc
  Desc
}

fn map_order_by_direction_constructor(in: Direction) -> OrderByDirection {
  case in {
    Asc -> read_query.Asc
    Desc -> read_query.Desc
  }
}

/// Creates or appends an ascending `OrderBy`.
///
pub fn order_by_asc(
  query qry: Combined(param),
  by ordb: String,
) -> Combined(param) {
  qry
  |> read_query.combined_order_by(
    by: [ordb |> OrderByColumn(read_query.Asc)] |> OrderBy,
    append: True,
  )
}

/// Creates or appends an ascending `OrderBy` with `NULLS FIRST`.
///
/// NOTICE: 🦭MariaDB and 🐬MySQL do not support `NULLS FIRST` out of the box.
///
pub fn order_by_asc_nulls_first(
  query qry: Combined(param),
  by ordb: String,
) -> Combined(param) {
  qry
  |> read_query.combined_order_by(
    by: [ordb |> OrderByColumn(read_query.AscNullsFirst)] |> OrderBy,
    append: True,
  )
}

/// Creates or appends an ascending `OrderBy` with `NULLS LAST`.
///
/// NOTICE: 🦭MariaDB and 🐬MySQL do not support `NULLS LAST` out of the box.
///
pub fn order_by_asc_nulls_last(
  query qry: Combined(param),
  by ordb: String,
) -> Combined(param) {
  qry
  |> read_query.combined_order_by(
    by: [ordb |> OrderByColumn(read_query.AscNullsFirst)] |> OrderBy,
    append: True,
  )
}

/// Replaces the `OrderBy` a single ascending `OrderBy`.
///
pub fn replace_order_by_asc(
  query qry: Combined(param),
  by ordb: String,
) -> Combined(param) {
  qry
  |> read_query.combined_order_by(
    by: [ordb |> OrderByColumn(read_query.Asc)] |> OrderBy,
    append: False,
  )
}

/// Replaces the `OrderBy` a single ascending `OrderBy` with `NULLS FIRST`.
///
/// NOTICE: 🦭MariaDB and 🐬MySQL do not support `NULLS FIRST` out of the box.
///
pub fn replace_order_by_asc_nulls_first(
  query qry: Combined(param),
  by ordb: String,
) -> Combined(param) {
  qry
  |> read_query.combined_order_by(
    by: [ordb |> OrderByColumn(read_query.AscNullsFirst)] |> OrderBy,
    append: False,
  )
}

/// Replaces the `OrderBy` a single ascending `OrderBy` with `NULLS LAST`.
///
/// NOTICE: 🦭MariaDB and 🐬MySQL do not support `NULLS LAST` out of the box.
///
pub fn replace_order_by_asc_nulls_last(
  query qry: Combined(param),
  by ordb: String,
) -> Combined(param) {
  qry
  |> read_query.combined_order_by(
    by: [ordb |> OrderByColumn(read_query.AscNullsFirst)] |> OrderBy,
    append: False,
  )
}

/// Creates or appends a descending `OrderBy`.
///
pub fn order_by_desc(
  query qry: Combined(param),
  by ordb: String,
) -> Combined(param) {
  qry
  |> read_query.combined_order_by(
    by: [ordb |> OrderByColumn(read_query.Desc)] |> OrderBy,
    append: True,
  )
}

/// Creates or appends a descending order with `NULLS FIRST`.
///
/// NOTICE: 🦭MariaDB and 🐬MySQL do not support `NULLS FIRST` out of the box.
///
pub fn order_by_desc_nulls_first(
  query qry: Combined(param),
  by ordb: String,
) -> Combined(param) {
  qry
  |> read_query.combined_order_by(
    by: [ordb |> OrderByColumn(read_query.DescNullsFirst)] |> OrderBy,
    append: True,
  )
}

/// Creates or appends a descending `OrderBy` with `NULLS LAST`.
///
/// NOTICE: 🦭MariaDB and 🐬MySQL do not support `NULLS LAST` out of the box.
///
pub fn order_by_desc_nulls_last(
  query qry: Combined(param),
  by ordb: String,
) -> Combined(param) {
  qry
  |> read_query.combined_order_by(
    by: [ordb |> OrderByColumn(read_query.DescNullsFirst)] |> OrderBy,
    append: True,
  )
}

/// Replaces the `OrderBy` a single descending order.
///
pub fn replace_order_by_desc(
  query qry: Combined(param),
  by ordb: String,
) -> Combined(param) {
  qry
  |> read_query.combined_order_by(
    by: [ordb |> OrderByColumn(read_query.Desc)] |> OrderBy,
    append: False,
  )
}

/// Replaces the `OrderBy` a single descending order with `NULLS FIRST`.
///
/// NOTICE: 🦭MariaDB and 🐬MySQL do not support `NULLS FIRST` out of the box.
///
pub fn replace_order_by_desc_nulls_first(
  query qry: Combined(param),
  by ordb: String,
) -> Combined(param) {
  qry
  |> read_query.combined_order_by(
    by: [ordb |> OrderByColumn(read_query.DescNullsFirst)] |> OrderBy,
    append: False,
  )
}

/// Replaces the `OrderBy` a single descending `OrderBy` with `NULLS LAST`.
///
/// NOTICE: 🦭MariaDB and 🐬MySQL do not support `NULLS LAST` out of the box.
///
pub fn replace_order_by_desc_nulls_last(
  query qry: Combined(param),
  by ordb: String,
) -> Combined(param) {
  qry
  |> read_query.combined_order_by(
    by: [ordb |> OrderByColumn(read_query.DescNullsFirst)] |> OrderBy,
    append: False,
  )
}

/// Creates or appends an `OrderBy` a column with a direction.
///
/// The direction can either `ASC` or `DESC`.
///
pub fn order_by(
  query qry: Combined(param),
  by ordb: String,
  direction dir: Direction,
) -> Combined(param) {
  let dir = dir |> map_order_by_direction_constructor
  qry
  |> read_query.combined_order_by(
    [ordb |> OrderByColumn(direction: dir)] |> OrderBy,
    True,
  )
}

/// Replaces the `OrderBy` a column with a direction.
///
pub fn replace_order_by(
  query qry: Combined(param),
  by ordb: String,
  direction dir: Direction,
) -> Combined(param) {
  let dir = dir |> map_order_by_direction_constructor
  qry
  |> read_query.combined_order_by(
    [ordb |> OrderByColumn(direction: dir)] |> OrderBy,
    False,
  )
}

/// Removes the `OrderBy` from the `Combined` read_query.
///
pub fn no_order_by(query qry: Combined(param)) -> Combined(param) {
  Combined(..qry, order_by: NoOrderBy)
}

/// Gets the `OrderBy` from the `Combined` read_query.
///
pub fn get_order_by(query qry: Combined(param)) -> OrderBy(param) {
  qry.order_by
}

// ▒▒▒ EPILOG ▒▒▒

/// Appends an `Epilog` to the `Combined` read_query.
///
pub fn epilog(
  query qry: Combined(param),
  epilog eplg: String,
) -> Combined(param) {
  let eplg = eplg |> string.trim
  case eplg {
    "" -> Combined(..qry, epilog: NoEpilog)
    _ -> Combined(..qry, epilog: { " " <> eplg } |> Epilog)
  }
}

/// Removes the `Epilog` from the `Combined` read_query.
///
pub fn no_epilog(query qry: Combined(param)) -> Combined(param) {
  Combined(..qry, epilog: NoEpilog)
}

/// Gets the `Epilog` from the `Combined` read_query.
///
pub fn get_epilog(query qry: Combined(param)) -> Epilog {
  qry.epilog
}

// ▒▒▒ COMMENT ▒▒▒

/// Appends a `Comment` to the `Combined` read_query.
///
pub fn comment(
  query qry: Combined(param),
  comment cmmnt: String,
) -> Combined(param) {
  let cmmnt = cmmnt |> string.trim
  case cmmnt {
    "" -> Combined(..qry, comment: NoComment)
    _ -> Combined(..qry, comment: { " " <> cmmnt } |> Comment)
  }
}

/// Removes the `Comment` from the `Combined` read_query.
///
pub fn no_comment(query qry: Combined(param)) -> Combined(param) {
  Combined(..qry, comment: NoComment)
}

/// Gets the `Comment` from the `Combined` read_query.
///
pub fn get_comment(query qry: Combined(param)) -> Comment {
  qry.comment
}
