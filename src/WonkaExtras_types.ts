import { sourceT } from 'wonka/src/Wonka_types.gen'

export declare type sources = {
  <A, B>(sources: [sourceT<A>, sourceT<B>]): sourceT<[A, B]>
  <A, B, C>(sources: [sourceT<A>, sourceT<B>, sourceT<C>]): sourceT<[A, B, C]>
  <A, B, C, D>(sources: [sourceT<A>, sourceT<B>, sourceT<C>, sourceT<D>]): sourceT<[A, B, C, D]>
  <A, B, C, D, E>(sources: [sourceT<A>, sourceT<B>, sourceT<C>, sourceT<D>, sourceT<E>]): sourceT<
    [A, B, C, D, E]
  >
  <A, B, C, D, E, F>(
    sources: [sourceT<A>, sourceT<B>, sourceT<C>, sourceT<D>, sourceT<E>, sourceT<F>],
  ): sourceT<[A, B, C, D, E, F]>
  <A, B, C, D, E, F, G>(
    sources: [sourceT<A>, sourceT<B>, sourceT<C>, sourceT<D>, sourceT<E>, sourceT<F>, sourceT<G>],
  ): sourceT<[A, B, C, D, E, F, G]>
  <A, B, C, D, E, F, G, H>(
    sources: [
      sourceT<A>,
      sourceT<B>,
      sourceT<C>,
      sourceT<D>,
      sourceT<E>,
      sourceT<F>,
      sourceT<G>,
      sourceT<H>,
    ],
  ): sourceT<[A, B, C, D, E, F, G, H]>
  <A, B, C, D, E, F, G, H, I>(
    sources: [
      sourceT<A>,
      sourceT<B>,
      sourceT<C>,
      sourceT<D>,
      sourceT<E>,
      sourceT<F>,
      sourceT<G>,
      sourceT<H>,
      sourceT<I>,
    ],
  ): sourceT<[A, B, C, D, E, F, G, H, I]>
  <A, B, C, D, E, F, G, H, I, J>(
    sources: [
      sourceT<A>,
      sourceT<B>,
      sourceT<C>,
      sourceT<D>,
      sourceT<E>,
      sourceT<F>,
      sourceT<G>,
      sourceT<H>,
      sourceT<I>,
      sourceT<J>,
    ],
  ): sourceT<[A, B, C, D, E, F, G, H, I, J]>
  <A, B, C, D, E, F, G, H, I, J, K>(
    sources: [
      sourceT<A>,
      sourceT<B>,
      sourceT<C>,
      sourceT<D>,
      sourceT<E>,
      sourceT<F>,
      sourceT<G>,
      sourceT<H>,
      sourceT<I>,
      sourceT<J>,
      sourceT<K>,
    ],
  ): sourceT<[A, B, C, D, E, F, G, H, I, J, K]>
  <A, B, C, D, E, F, G, H, I, J, K, L>(
    sources: [
      sourceT<A>,
      sourceT<B>,
      sourceT<C>,
      sourceT<D>,
      sourceT<E>,
      sourceT<F>,
      sourceT<G>,
      sourceT<H>,
      sourceT<I>,
      sourceT<J>,
      sourceT<K>,
      sourceT<L>,
    ],
  ): sourceT<[A, B, C, D, E, F, G, H, I, J, K, L]>
  <A, B, C, D, E, F, G, H, I, J, K, L, M>(
    sources: [
      sourceT<A>,
      sourceT<B>,
      sourceT<C>,
      sourceT<D>,
      sourceT<E>,
      sourceT<F>,
      sourceT<G>,
      sourceT<H>,
      sourceT<I>,
      sourceT<J>,
      sourceT<K>,
      sourceT<L>,
      sourceT<M>,
    ],
  ): sourceT<[A, B, C, D, E, F, G, H, I, J, K, L, M]>
  <A, B, C, D, E, F, G, H, I, J, K, L, M, N>(
    sources: [
      sourceT<A>,
      sourceT<B>,
      sourceT<C>,
      sourceT<D>,
      sourceT<E>,
      sourceT<F>,
      sourceT<G>,
      sourceT<H>,
      sourceT<I>,
      sourceT<J>,
      sourceT<K>,
      sourceT<L>,
      sourceT<M>,
      sourceT<N>,
    ],
  ): sourceT<[A, B, C, D, E, F, G, H, I, J, K, L, M, N]>
}

export declare const forkJoin: sources
export declare const combineLatest: sources
