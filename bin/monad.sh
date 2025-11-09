#!/usr/bin/env bash
# monad.sh — Functional shell primitives for safe, composable workflows

# --- Core Monad Primitives ---

maybe() {
  local value="$1"
  if [[ -n "$value" ]]; then
    echo "Just \"$value\""
  else
    echo "Nothing"
    return 1
  fi
}

maybe_unwrap() {
  local wrapped="$1"
  if [[ "$wrapped" =~ ^Just\ \"(.*)\"$ ]]; then
    echo "${BASH_REMATCH[1]}"
  else
    echo "Error: Cannot unwrap Nothing" >&2
    return 1
  fi
}

maybe_bind() {
  local wrapped="$1"
  local func="$2"
  if [[ "$wrapped" =~ ^Just\ \"(.*)\"$ ]]; then
    "$func" "${BASH_REMATCH[1]}"
  else
    echo "Nothing"
    return 1
  fi
}

# --- Optional: Pure Transformations ---

#maybe_map() {
#  local wrapped="$1"
#  local func="$2"
#  if [[ "$wrapped" =~ ^Just\ \"(.*)\"$ ]]; then
#    maybe "$("$func" "${BASH_REMATCH[1]}")"
#  else
#    echo "Nothing"
#    return 1
#  fi
#}

# Maybe functor (simplified)
maybe_map() {
    local maybe="$1" func="$2"
    if [[ -z "$maybe" ]] || [[ "$maybe" == "NULL" ]]; then
        echo "NULL"
    else
        $func "$maybe"
    fi
}

maybe_flatMap() {
  local wrapped="$1"
  local func="$2"
  if [[ "$wrapped" =~ ^Just\ \"(.*)\"$ ]]; then
    "$func" "${BASH_REMATCH[1]}"
  else
    echo "Nothing"
    return 1
  fi
}


