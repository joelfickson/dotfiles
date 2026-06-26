---
name: tanstack-query
description: Use when building React components that fetch, mutate, or synchronize server state. Triggers - API calls, data loading, form submissions, CRUD operations, pagination, optimistic UI updates, cache invalidation. Never use useEffect for data fetching.
---

# TanStack Query Data Fetching & Mutations

## Core Principle

**Never use useEffect for data fetching or server state synchronization.** All server state flows through TanStack Query hooks. Components depend entirely on hook return values (isPending, isError, data, error) - no local useState for loading/error tracking.

## When to Use

- Any component that reads from or writes to a server/API
- Form submissions, CRUD operations, file uploads
- Pagination, infinite scroll, search-as-you-type
- Prefetching on hover/focus, background refetching
- Optimistic UI updates

## When NOT to Use

- Pure client state (form inputs, UI toggles, modals) - use useState/useReducer
- Derived/computed values from existing query data - use `select` option
- One-time client-side calculations - not server state

## Setup

```tsx
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { ReactQueryDevtools } from "@tanstack/react-query-devtools";

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      staleTime: 1000 * 60 * 5,
      gcTime: 1000 * 60 * 60,
      refetchOnWindowFocus: false,
      retry: 1,
    },
  },
});

function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <YourApp />
      <ReactQueryDevtools initialIsOpen={false} />
    </QueryClientProvider>
  );
}
```

## Query Key Factory

Define all query keys in a single factory per domain. This prevents key duplication and makes invalidation predictable.

```tsx
export const todoKeys = {
  all: ["todos"] as const,
  lists: () => [...todoKeys.all, "list"] as const,
  list: (filters: TodoFilters) => [...todoKeys.lists(), filters] as const,
  details: () => [...todoKeys.all, "detail"] as const,
  detail: (id: string) => [...todoKeys.details(), id] as const,
};
```

## Query Options Factory

Use `queryOptions` to define reusable, type-safe query configurations. Share across `useQuery`, `useSuspenseQuery`, `prefetchQuery`, and `ensureQueryData`.

```tsx
import { queryOptions } from "@tanstack/react-query";

export const todoListOptions = (filters: TodoFilters) =>
  queryOptions({
    queryKey: todoKeys.list(filters),
    queryFn: () => api.getTodos(filters),
  });

export const todoDetailOptions = (id: string) =>
  queryOptions({
    queryKey: todoKeys.detail(id),
    queryFn: () => api.getTodo(id),
  });
```

## Custom Hooks

Every query and mutation gets its own custom hook. Components never call `useQuery` or `useMutation` directly.

### Query Hook

```tsx
export function useTodos(filters: TodoFilters) {
  return useQuery(todoListOptions(filters));
}

export function useTodo(id: string) {
  return useQuery(todoDetailOptions(id));
}
```

### Mutation Hook

```tsx
export function useCreateTodo() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (newTodo: CreateTodoInput) => api.createTodo(newTodo),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: todoKeys.lists() });
    },
  });
}

export function useUpdateTodo() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ id, ...data }: UpdateTodoInput) => api.updateTodo(id, data),
    onSuccess: (_data, variables) => {
      queryClient.invalidateQueries({ queryKey: todoKeys.detail(variables.id) });
      queryClient.invalidateQueries({ queryKey: todoKeys.lists() });
    },
  });
}

export function useDeleteTodo() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (id: string) => api.deleteTodo(id),
    onSuccess: (_data, id) => {
      queryClient.removeQueries({ queryKey: todoKeys.detail(id) });
      queryClient.invalidateQueries({ queryKey: todoKeys.lists() });
    },
  });
}
```

## Component Usage

Components consume hooks and depend only on their return values. No useEffect, no local loading/error state.

```tsx
function TodoList({ filters }: { filters: TodoFilters }) {
  const { data: todos, isPending, isError, error } = useTodos(filters);

  if (isPending) return <Skeleton />;
  if (isError) return <ErrorDisplay error={error} />;

  return (
    <ul>
      {todos.map((todo) => (
        <TodoItem key={todo.id} todo={todo} />
      ))}
    </ul>
  );
}

function CreateTodoForm() {
  const createTodo = useCreateTodo();

  const handleSubmit = (data: CreateTodoInput) => {
    createTodo.mutate(data);
  };

  return (
    <form onSubmit={handleFormSubmit(handleSubmit)}>
      {/* form fields */}
      <button type="submit" disabled={createTodo.isPending}>
        {createTodo.isPending ? "Creating..." : "Create"}
      </button>
      {createTodo.isError && <ErrorMessage error={createTodo.error} />}
    </form>
  );
}
```

## Optimistic Updates

Use the `variables` approach (v5 preferred) - no manual cache manipulation needed.

```tsx
export function useToggleTodo() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ id, completed }: { id: string; completed: boolean }) =>
      api.updateTodo(id, { completed }),
    onMutate: async ({ id, completed }) => {
      await queryClient.cancelQueries({ queryKey: todoKeys.detail(id) });

      const previous = queryClient.getQueryData(todoKeys.detail(id));

      queryClient.setQueryData(todoKeys.detail(id), (old: Todo | undefined) =>
        old ? { ...old, completed } : old
      );

      return { previous };
    },
    onError: (_err, { id }, context) => {
      if (context?.previous) {
        queryClient.setQueryData(todoKeys.detail(id), context.previous);
      }
    },
    onSettled: (_data, _err, { id }) => {
      queryClient.invalidateQueries({ queryKey: todoKeys.detail(id) });
    },
  });
}
```

For simple display-only optimism (no rollback needed), use `variables` from the pending mutation directly in the UI:

```tsx
function TodoItem({ todo }: { todo: Todo }) {
  const toggleTodo = useToggleTodo();

  const displayCompleted = toggleTodo.isPending
    ? toggleTodo.variables.completed
    : todo.completed;

  return (
    <li style={{ opacity: toggleTodo.isPending ? 0.5 : 1 }}>
      <input
        type="checkbox"
        checked={displayCompleted}
        onChange={() => toggleTodo.mutate({ id: todo.id, completed: !todo.completed })}
      />
      {todo.title}
    </li>
  );
}
```

## Key Patterns

### Dependent Queries

```tsx
function useUserPosts(userId: string) {
  const { data: user } = useQuery({
    queryKey: ["user", userId],
    queryFn: () => api.getUser(userId),
  });

  return useQuery({
    queryKey: ["posts", user?.id],
    queryFn: () => api.getPosts(user!.id),
    enabled: !!user?.id,
  });
}
```

### Parallel Queries

```tsx
const results = useQueries({
  queries: ids.map((id) => ({
    queryKey: todoKeys.detail(id),
    queryFn: () => api.getTodo(id),
  })),
  combine: (results) => ({
    data: results.map((r) => r.data).filter(Boolean),
    isPending: results.some((r) => r.isPending),
  }),
});
```

### Prefetching

```tsx
function TodoListItem({ id, title }: { id: string; title: string }) {
  const queryClient = useQueryClient();

  const handleHover = () => {
    queryClient.prefetchQuery(todoDetailOptions(id));
  };

  return <li onMouseEnter={handleHover}>{title}</li>;
}
```

### Infinite Scroll

```tsx
export function useInfiniteTodos() {
  return useInfiniteQuery({
    queryKey: todoKeys.lists(),
    queryFn: ({ pageParam }) => api.getTodos({ cursor: pageParam }),
    initialPageParam: 0,
    getNextPageParam: (lastPage) => lastPage.nextCursor ?? undefined,
  });
}
```

### Data Transformation with select

```tsx
export function useCompletedTodos() {
  return useQuery({
    ...todoListOptions({}),
    select: (data) => data.filter((t) => t.completed),
  });
}
```

### Query Cancellation

```tsx
queryFn: async ({ signal }) => {
  const res = await fetch(`/api/search?q=${query}`, { signal });
  if (!res.ok) throw new Error("Search failed");
  return res.json();
},
```

## File Organization

```
src/
  features/
    todos/
      api/
        todo.keys.ts       # Query key factory
        todo.queries.ts     # queryOptions + query hooks
        todo.mutations.ts   # Mutation hooks
      components/
        TodoList.tsx
        TodoForm.tsx
```

## Quick Reference

| Need | Solution |
|------|----------|
| Fetch data | `useQuery` via custom hook |
| Submit/modify data | `useMutation` via custom hook |
| Loading state | `isPending` from hook |
| Error state | `isError` + `error` from hook |
| Background refetch indicator | `isFetching` from hook |
| Refetch after mutation | `queryClient.invalidateQueries()` in `onSuccess` |
| Transform response data | `select` option on query |
| Wait for another query | `enabled: !!dependency` |
| Fetch on hover | `queryClient.prefetchQuery()` |
| Paginated data | `useInfiniteQuery` |
| Multiple parallel fetches | `useQueries` with `combine` |
| Optimistic UI (simple) | `variables` + `isPending` from mutation |
| Optimistic UI (rollback) | `onMutate` / `onError` / `onSettled` pattern |
| Remove cached entry | `queryClient.removeQueries()` |
| Share query config | `queryOptions()` factory |

## Anti-Patterns (Never Do)

| Anti-Pattern | Do Instead |
|---|---|
| `useEffect` + `useState` for fetching | `useQuery` custom hook |
| `useState(false)` for loading | `isPending` from query/mutation |
| `useState(null)` for error | `isError` + `error` from query/mutation |
| `useQuery` directly in components | Custom hook wrapping `useQuery` |
| String query keys `"todos"` | Array keys `["todos"]` via key factory |
| Manual `refetch()` after param change | Include params in `queryKey` - auto-refetches |
| `onSuccess`/`onError` on queries | Removed in v5 - use returned state |
| `isLoading` for "no data yet" | `isPending` (v5 renamed it) |
| `cacheTime` | `gcTime` (v5 renamed it) |
| Inline `queryKey` arrays everywhere | Centralized key factory |
| Cache manipulation for optimistic UI | Use `variables` from pending mutation when possible |

## v5 Gotchas

- `onSuccess`/`onError`/`onSettled` callbacks removed from `useQuery` (still work on `useMutation`)
- `isLoading` changed meaning: now equals `isPending && isFetching`. Use `isPending` for "no data yet"
- `keepPreviousData` removed: use `placeholderData: keepPreviousData` (import the helper)
- `useErrorBoundary` renamed to `throwOnError`
- Infinite queries require `initialPageParam`
- `enabled` not available on `useSuspenseQuery` - use conditional rendering
- `invalidateQueries` only refetches active (mounted) queries - use `refetchType: "all"` for inactive ones
